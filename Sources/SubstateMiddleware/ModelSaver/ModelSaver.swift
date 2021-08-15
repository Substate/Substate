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
    private var cachedUpdateFunction: Update? // TODO: How can we get around this?

    private var initialConfiguration: Configuration

    /// Create a new `ModelSaver` with the given configuration.
    ///
    public init(configuration: Configuration = .initial) {
        self.initialConfiguration = configuration
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
            .sink { self.cachedUpdateFunction?(SaveAll()) }
            .store(in: &subscriptions)
    }

    // MARK: - Middleware API

    public func update(update: @escaping Update, find: @escaping Find) -> (@escaping Update) -> Update {
        { next in
            { [self] action in
                switch action {
                case is Store.Start:
                    update(Store.Register(model: initialConfiguration))
                    update(Setup())
                case is Setup:
                    // TODO: Factor out
                    cachedUpdateFunction = update
                    let configuration = find(Configuration.self).first as! Configuration

                    if configuration.loadStrategy == .automatic {
                        update(LoadAll())
                    }
                case let action as Load: load(type: action.type, using: find, and: update)
                case let action as Save: save(type: action.type, using: find, and: update)
                case is LoadAll: loadAll(using: find, and: update)
                case is SaveAll: saveAll(using: find, and: update)

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

    private func loadAll(using find: Find, and update: @escaping Update) {
        find(nil).forEach { model in
            if model is SavedModel {
                load(type: type(of: model), using: find, and: update)
            }
        }
    }

    private func load(type: Model.Type, using find: Find, and update: @escaping Update) {
        let configuration = find(Configuration.self).first as! Configuration

        guard let savedModelType = type as? SavedModel.Type else {
            update(LoadDidFail(for: type, with: .modelIsNotASavedModel))
            return
        }

        configuration.load(savedModelType)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    update(LoadDidFail(for: type, with: error))
                }
            } receiveValue: { model in
                let loadedType = Swift.type(of: model)
                if loadedType == type {
                    update(LoadDidSucceed(with: model))
                    if configuration.updateStrategy == .automatic {
                        update(Store.Replace(model: model))
                        update(UpdateDidComplete(type: type))
                    }
                } else {
                    update(LoadDidFail(for: type, with: .wrongModelTypeReturned))
                }

            }
            .store(in: &subscriptions)
    }

    // MARK: - Saving

    private func saveAll(using find: Find, and update: @escaping Update) {
        find(nil).forEach { model in
            if model is SavedModel {
                save(type: type(of: model), using: find, and: update)
            }
        }
    }

    private func save(type: Model.Type, using find: Find, and update: @escaping Update) {
        let configuration = find(Configuration.self).first as! Configuration

        guard let match = find(nil).first(where: { Swift.type(of: $0) == type }) else {
            update(SaveDidFail(for: type, with: .modelNotFound))
                return
            }

        guard let model = match as? SavedModel else {
            update(SaveDidFail(for: type, with: .modelIsNotASavedModel))
            return
        }

        configuration.save(model)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    update(SaveDidSucceed(for: type))
                case .failure(let error):
                    update(SaveDidFail(for: type, with: error))
                }
            } receiveValue: { _ in }
            .store(in: &self.subscriptions)
    }



}
