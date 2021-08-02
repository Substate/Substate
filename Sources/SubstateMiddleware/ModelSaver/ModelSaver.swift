import Foundation
import Combine
import Substate

/// Save and load models to persistent storage.
///
public class ModelSaver: Middleware {

    // MARK: - Initialisation

    private var subscriptions: [AnyCancellable] = []

    private let actionSubject = PassthroughSubject<Action, Never>()
    private var saveTrigger: AnyPublisher<Void, Never>
    private var storeCache: Store? // TODO: How can we get around this? It sucks to keep a reference to the store!

    /// Create a new `ModelSaver` with the given configuration.
    ///
    public init(configuration: Configuration = .initial) {
        self.model = configuration
        print(NSHomeDirectory())

        // TODO: Factor out this setup and be able to redo it cleanly if configuration is updated
        switch configuration.saveStrategy {
        case .manual:
            saveTrigger = Empty().eraseToAnyPublisher()
        case .periodic(let interval):
            saveTrigger = Timer.publish(every: interval, on: RunLoop.main, in: .common)
                .autoconnect()
                .map { _ in }
                .eraseToAnyPublisher()
        case .debounced(let interval):
            saveTrigger = actionSubject
                .debounce(for: .seconds(interval), scheduler: RunLoop.main)
                .map { _ in }
                .eraseToAnyPublisher()
        case .throttled(let interval):
            saveTrigger = actionSubject
                .throttle(for: .seconds(interval), scheduler: RunLoop.main, latest: true)
                .map { _ in }
                .eraseToAnyPublisher()
        }

        saveTrigger
            .sink { self.storeCache?.update(SaveAll()) }
            .store(in: &subscriptions)
    }

    // MARK: - Middleware API

    public var model: Model?

    public func setup(store: Store) {
        storeCache = store // Ugh...
        let configuration = store.find(Configuration.self)!

        if configuration.loadStrategy == .automatic {
            store.update(LoadAll())
        }
    }

    public func update(store: Store) -> (@escaping Update) -> Update {
        { next in
            { [self] action in
                switch action {
                case let action as Load: load(type: action.type, using: store)
                case let action as Save: save(type: action.type, using: store)
                case is LoadAll: loadAll(using: store)
                case is SaveAll: saveAll(using: store)

                case is LoadDidSucceed, is LoadDidFail: ()
                case is SaveDidSucceed, is SaveDidFail: ()

                // TODO: Handle any setup needed after a configuration update.
                // NOTE: Would need to let the middleware chain complete to get new config value
                default:
                    actionSubject.send(action)
                }

                next(action)

            }
        }

    }

    // MARK: - Loading

    private func loadAll(using store: Store) {
        store.allModels.forEach { model in
            if model is SavedModel {
                load(type: type(of: model), using: store)
            }
        }
    }

    private func load(type: Model.Type, using store: Store) {
        let configuration = store.find(Configuration.self)!

        guard let savedModelType = type as? SavedModel.Type else {
            store.update(LoadDidFail(for: type, with: .modelIsNotASavedModel))
            return
        }

        configuration.load(savedModelType)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    store.update(LoadDidFail(for: type, with: error))
                }
            } receiveValue: { model in
                let loadedType = Swift.type(of: model)
                if loadedType == type {
                    store.update(LoadDidSucceed(with: model))
                    if configuration.updateStrategy == .automatic {
                        store.update(Store.Replace(model: model))
                        store.update(UpdateDidComplete(type: type))
                    }
                } else {
                    store.update(LoadDidFail(for: type, with: .wrongModelTypeReturned))
                }

            }
            .store(in: &subscriptions)
    }

    // MARK: - Saving

    private func saveAll(using store: Store) {
        store.allModels.forEach { model in
            if model is SavedModel {
                save(type: type(of: model), using: store)
            }
        }
    }

    private func save(type: Model.Type, using store: Store) {
        let configuration = store.find(Configuration.self)!

        guard let match = store.allModels.first(where: { Swift.type(of: $0) == type }) else {
            store.update(SaveDidFail(for: type, with: .modelNotFound))
                return
            }

        guard let model = match as? SavedModel else {
            store.update(SaveDidFail(for: type, with: .modelIsNotASavedModel))
            return
        }

        configuration.save(model)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    store.update(SaveDidSucceed(for: type))
                case .failure(let error):
                    store.update(SaveDidFail(for: type, with: error))
                }
            } receiveValue: { _ in }
            .store(in: &self.subscriptions)
    }



}
