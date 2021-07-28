import Foundation
import Combine
import Substate

/// Save and load models via disk or network.
///
/// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut
/// labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris
/// nisi ut aliquip ex ea commodo consequat.
///
/// ```swift
/// let store = Store(model: Counter(), middleware: [ModelSaver()])
/// // - Substate.Action: SubstateMiddleware.ModelSaver.LoadAll
///
/// store.update(Counter.Increment())
/// // - Substate.Action: Example.Counter.Increment
///
/// store.update(ModelSaver.Save(Counter.self))
/// // - Substate.Action: SubstateMiddleware.ModelSaver.Save
/// // - Substate.Action: SubstateMiddleware.ModelSaver.SaveDidSucceed
/// ```
///
/// ## Customising Load & Save Behaviour
///
/// Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
/// pariatur. Excepteur sint occaecat cupidatat non proident sunt in culpa qui officia deserunt
/// mollit anim id est laborum.
///
/// ```swift
/// let saver = ModelSaver(configuration: .init(saveStrategy: .debounce(5)))
/// ```
///
public class ModelSaver: Middleware {

    // MARK: - Initialisation

    private var subscriptions: [AnyCancellable] = []

    public init(configuration: Configuration = .initial) {
        self.model = configuration
        print(NSHomeDirectory())
    }

    // MARK: - Middleware API

    public var model: Model?

    public func setup(store: Store) {
        let configuration = store.find(Configuration.self)!

        if configuration.loadStrategy == .automatic {
            store.update(LoadAll())
        }
    }

    public func update(store: Store) -> (@escaping Update) -> Update {
        { next in
            { action in
                switch action {
                case let action as Load: self.load(type: action.type, using: store)
                case let action as Save: self.save(type: action.type, using: store)
                case is LoadAll: self.loadAll(using: store)
                case is SaveAll: self.saveAll(using: store)
                default: ()
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
                let t = Swift.type(of: model)
                if t == type {
                    store.update(LoadDidSucceed(with: model))
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
