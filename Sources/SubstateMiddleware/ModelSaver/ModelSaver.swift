//import Foundation
//import Combine
//import Substate
//
///// Save and load models to persistent storage.
/////
//public class ModelSaver: Middleware {
//
//    // MARK: - Initialisation
//
//    private var subscriptions: [AnyCancellable] = []
//
//    private let actionSubject = PassthroughSubject<Action, Never>()
//    private var saveTrigger: AnyPublisher<Void, Never>
//    private var cachedSendFunction: Send? // TODO: How can we get around this?
//
//    private var initialConfiguration: Configuration
//
//    /// Create a new `ModelSaver` with the given configuration.
//    ///
//    public init(configuration: Configuration = .initial) {
//        self.initialConfiguration = configuration
//        print(NSHomeDirectory())
//
//        // TODO: Factor out this setup and be able to redo it cleanly if configuration is updated
//        switch configuration.saveStrategy {
//        case .manual:
//            saveTrigger = Empty().eraseToAnyPublisher()
//        case .periodic(let interval):
//            saveTrigger = Timer.publish(every: interval, on: RunLoop.main, in: .common)
//                .autoconnect()
//                .map { _ in }
//                .eraseToAnyPublisher()
//        case .debounced(let interval):
//            saveTrigger = actionSubject
//                .debounce(for: .seconds(interval), scheduler: RunLoop.main)
//                .map { _ in }
//                .eraseToAnyPublisher()
//        case .throttled(let interval):
//            saveTrigger = actionSubject
//                .throttle(for: .seconds(interval), scheduler: RunLoop.main, latest: true)
//                .map { _ in }
//                .eraseToAnyPublisher()
//        }
//
//        saveTrigger
//            .sink { self.cachedSendFunction?(SaveAll()) }
//            .store(in: &subscriptions)
//    }
//
//    // MARK: - Middleware API
//
//    public func update(send: @escaping Send, find: @escaping Find) -> (@escaping Send) -> Send {
//        { next in
//            { [self] action in
//                switch action {
//                case is Store.Start:
//                    send(Store.Register(model: initialConfiguration))
//                    send(Start())
//                case is Start:
//                    // TODO: Factor out
//                    cachedSendFunction = send
//                    let configuration = find(Configuration.self).first as! Configuration
//
//                    if configuration.loadStrategy == .automatic {
//                        send(LoadAll())
//                    }
//                case let action as Load: load(type: action.type, using: find, and: send)
//                case let action as Save: save(type: action.type, using: find, and: send)
//                case is LoadAll: loadAll(using: find, and: send)
//                case is SaveAll: saveAll(using: find, and: send)
//
//                case is LoadDidSucceed, is LoadDidFail, is LoadDidComplete: ()
//                case is SaveDidSucceed, is SaveDidFail, is SaveDidComplete: ()
//
//                // TODO: Handle any setup needed after a configuration update.
//                // NOTE: Would need to let the middleware chain complete to get new config value
//                default:
//                    actionSubject.send(action)
//                }
//
//                next(action)
//
//            }
//        }
//
//    }
//
//    // MARK: - Loading
//
//    private func loadAll(using find: Find, and send: @escaping Send) {
//        // TODO: Keep track of these tasks, await them all, and provide a 'RestoreAllDidComplete' action.
//        find(nil).forEach { model in
//            if model is SavedModel {
//                load(type: type(of: model), using: find, and: send)
//            }
//        }
//    }
//
//    private func load(type: Model.Type, using find: Find, and send: @escaping Send) {
//        let configuration = find(Configuration.self).first as! Configuration
//
//        guard let savedModelType = type as? SavedModel.Type else {
//            send(LoadDidFail(for: type, with: .modelIsNotASavedModel))
//            return
//        }
//
//        configuration.load(savedModelType)
//            .receive(on: DispatchQueue.main)
//            .sink { completion in
//                if case .failure(let error) = completion {
//                    send(LoadDidFail(for: type, with: error))
//                    send(LoadDidComplete(type: type))
//                }
//            } receiveValue: { model in
//                assert(Thread.isMainThread)
//                let loadedType = Swift.type(of: model)
//                if loadedType == type {
//                    send(LoadDidSucceed(with: model))
//                    send(Store.Replace(model: model))
//                    send(LoadDidComplete(type: type))
//                } else {
//                    send(LoadDidFail(for: type, with: .wrongModelTypeReturned))
//                    send(LoadDidComplete(type: type))
//                }
//
//            }
//            .store(in: &subscriptions)
//    }
//
//    // MARK: - Saving
//
//    private func saveAll(using find: Find, and send: @escaping Send) {
//        find(nil).forEach { model in
//            if model is SavedModel {
//                save(type: type(of: model), using: find, and: send)
//            }
//        }
//    }
//
//    private func save(type: Model.Type, using find: Find, and send: @escaping Send) {
//        let configuration = find(Configuration.self).first as! Configuration
//
//        guard let match = find(nil).first(where: { Swift.type(of: $0) == type }) else {
//            send(SaveDidFail(for: type, with: .modelNotFound))
//                return
//            }
//
//        guard let model = match as? SavedModel else {
//            send(SaveDidFail(for: type, with: .modelIsNotASavedModel))
//            return
//        }
//
//        configuration.save(model)
//            .receive(on: DispatchQueue.main)
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    send(SaveDidSucceed(for: type))
//                    send(SaveDidComplete(for: type))
//                case .failure(let error):
//                    send(SaveDidFail(for: type, with: error))
//                    send(SaveDidComplete(for: type))
//                }
//            } receiveValue: { _ in }
//            .store(in: &self.subscriptions)
//    }
//
//
//
//}
