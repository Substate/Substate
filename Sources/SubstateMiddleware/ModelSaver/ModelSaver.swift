import Foundation
import CryptoKit
import Combine
import Substate

/// Save and load models to persistent storage.
///
public class ModelSaver: Middleware {

    // MARK: - Initialisation

    private var subscriptions: [AnyCancellable] = []

    private var saveTrigger: AnyPublisher<Void, Never>
    private let actionWasReceived = PassthroughSubject<Action, Never>()

    private var store: Store!
    private var initialConfiguration: Configuration
    private var modelCache: [String:SHA256Digest] = [:]

    /// Create a new `ModelSaver` with the given configuration.
    ///
    public init(configuration: Configuration = .initial) {
        self.initialConfiguration = configuration
        print("ModelSaver Folder:", NSHomeDirectory())

        /// TODO: Factor out this setup
        /// We want to be able to redo it cleanly if configuration is updated
        /// Should also try and implement using AsyncStream and ditch Combine
        switch configuration.saveStrategy {

        case .manual:
            saveTrigger = Empty().eraseToAnyPublisher()

        case .periodic(let interval):
            saveTrigger = Timer.publish(every: interval, on: RunLoop.main, in: .common)
                .autoconnect()
                .map { _ in }
                .eraseToAnyPublisher()

        case .debounced(let interval):
            saveTrigger = actionWasReceived
                .debounce(for: .seconds(interval), scheduler: RunLoop.main)
                .map { _ in }
                .eraseToAnyPublisher()

        case .throttled(let interval):
            saveTrigger = actionWasReceived
                .throttle(for: .seconds(interval), scheduler: RunLoop.main, latest: true)
                .map { _ in }
                .eraseToAnyPublisher()
        }
    }

    // MARK: - Middleware API

    public func configure(store: Store) -> (@escaping DispatchFunction) -> DispatchFunction {
        self.store = store

        saveTrigger
            .sink { store.dispatch(SaveAll()) }
            .store(in: &subscriptions)

        return { next in
            { [self] action in
                try await next(action)
                
                switch action {

                case is Store.Start:
                    try await store.dispatch(Store.Register(model: initialConfiguration))
                    try await store.dispatch(Start())

                case is Start:
                    if store.find(Configuration.self)?.loadStrategy == .automatic {
                        try await store.dispatch(LoadAll())
                    }

                case let action as Load:
                    do {
                        let model = try await load(type: action.type)
                        try await store.dispatch(LoadDidSucceed(with: model))
                        try await store.dispatch(Store.Replace(model: model))
                        try await store.dispatch(LoadDidComplete(for: action.type))
                    } catch {
                        try await store.dispatch(LoadDidFail(for: action.type, with: error))
                        try await store.dispatch(LoadDidComplete(for: action.type))
                    }

                case is LoadAll:
                    for model in store.find(SavedModel.self) {
                        let type = Swift.type(of: model)
                        do {
                            let result = try await load(type: type)
                            try await store.dispatch(LoadDidSucceed(with: result))
                            try await store.dispatch(Store.Replace(model: result))
                            try await store.dispatch(LoadDidComplete(for: type))
                        } catch {
                            try await store.dispatch(LoadDidFail(for: type, with: error))
                            try await store.dispatch(LoadDidComplete(for: type))
                        }
                    }
                    try await store.dispatch(LoadAllDidComplete())

                case let action as Save:
                    do {
                        try await save(type: action.type)
                        try await store.dispatch(SaveDidSucceed(for: action.type))
                        try await store.dispatch(SaveDidComplete(for: action.type))
                    } catch SaveError.saveNotNeeded {
                        // Don’t need to dispatch any new actions
                    } catch {
                        try await store.dispatch(SaveDidFail(for: action.type, with: error))
                        try await store.dispatch(SaveDidComplete(for: action.type))
                    }

                case is SaveAll:
                    for model in store.find(SavedModel.self) {
                        let type = Swift.type(of: model)
                        do {
                            try await save(type: type)
                            try await store.dispatch(SaveDidSucceed(for: type))
                            try await store.dispatch(SaveDidComplete(for: type))
                        } catch SaveError.saveNotNeeded {
                            // Don’t need to dispatch any new actions
                        } catch {
                            try await store.dispatch(SaveDidFail(for: type, with: error))
                            try await store.dispatch(SaveDidComplete(for: type))
                        }
                    }
                    try await store.dispatch(SaveAllDidComplete())

                case is LoadDidSucceed, is LoadDidFail, is LoadDidComplete, is LoadAllDidComplete:
                    () // Ignore these actions for auto-save

                case is SaveDidSucceed, is SaveDidFail, is SaveDidComplete, is SaveAllDidComplete:
                    () // Ignore these actions for auto-save

                default:
                    actionWasReceived.send(action)
                }
            }
        }
    }

    private func load(type: Model.Type) async throws -> Model {
        guard let configuration = await store.find(Configuration.self) else {
            throw LoadError.missingConfiguration
        }

        guard let savedModelType = type as? SavedModel.Type else {
            throw LoadError.modelIsNotASavedModel
        }

        let model = try await configuration.load(savedModelType)

        guard Swift.type(of: model) == type else {
            throw LoadError.wrongModelTypeReturned
        }

        if let savedModel = model as? SavedModel {
            modelCache[savedModel.saveCacheId] = savedModel.saveCacheHash
        }

        return model
    }

    private func save(type: Model.Type) async throws {
        guard let configuration = await store.find(Configuration.self) else {
            throw SaveError.missingConfiguration
        }

        guard let match = await store.find(type).first else {
            throw SaveError.modelNotFound
        }

        guard let model = match as? SavedModel else {
            throw SaveError.modelIsNotASavedModel
        }

        if let hash = modelCache[model.saveCacheId], hash == model.saveCacheHash {
            throw SaveError.saveNotNeeded
        }

        modelCache[model.saveCacheId] = model.saveCacheHash
        try await configuration.save(model)
    }

}
