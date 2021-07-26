import Foundation
import Combine
import Substate

/// Save and load models to and from disk.
///
/// ```swift
/// store.update(ModelSaver.Save(Counter.self))
/// ```
///
public class ModelSaver: Middleware {

    public var model: Model?

    private var subscriptions: [AnyCancellable] = []

    public init(configuration: Configuration = .initial) {
        self.model = configuration
        print(NSHomeDirectory())
    }

    public func setup(store: Store) {
        let configuration = store.find(Configuration.self)!

        if configuration.loadAllOnInit {
            store.update(LoadAll())
        }
    }

    public func update(store: Store) -> (@escaping Update) -> Update {
        { next in
            { action in

                switch action {

                case let action as Load:
                    ()

                // TODO: WTF, clean this up!
                case let action as Save:
                    guard let match = store.allModels.first(where: { type(of: $0) == action.type }) else {
                            store.update(SaveDidFail(type: action.type, error: .modelNotFound))
                            return
                        }

                    guard let model = match as? SavedModel else {
                        store.update(SaveDidFail(type: action.type, error: .modelIsNotASavedModel))
                        return
                    }

                    let configuration = store.find(Configuration.self)!

                    configuration.save(model)
                        .receive(on: DispatchQueue.main)
                        .sink { completion in
                            switch completion {
                            case .finished:
                                store.update(SaveDidSucceed(type: action.type))
                            case .failure(let error):
                                store.update(SaveDidFail(type: action.type, error: .unknown(error)))
                            }
                        } receiveValue: { _ in }
                        .store(in: &self.subscriptions)

                case is LoadAll:
                    ()
        //        for model in all {
        //            if let savedModel = model as? SavedModel {
        //                // Can use the cast saved model here to dispatch some load actions?
        //            }
        //        }

                case is SaveAll:
                    () // Just use the full list

                default:
                    ()
                }

                next(action)


            }
        }

    }


}
