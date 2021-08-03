import Substate

public class ActionFunneller: Middleware {

    // MARK: - Initialisation

    struct Configuration: Model {
        var funnels: [ActionFunnel]
        func update(action: Action) {}
    }

    private var configuration: Configuration

    public init(funnels: ActionFunnel...) {
        configuration = .init(funnels: funnels)
    }

    struct Start: Action {}
    public struct Complete: Action {
        public let target: Action.Type
    }

    // MARK: - Middleware API

    public var model: Model? = nil // { initialConfiguration } // For now since the Store isn’t fully recursive, we’re tracking our own state.

    public func setup(store: Store) {
        store.update(Start())
    }

    public func update(store: Store) -> (@escaping Update) -> Update {
        return { next in
            return { action in
                next(action)
                // ...

//                if let configuration = store.find(Configuration.self) {
//                  ...
//                }

                // Extremely clunky, but it’s a start!
                self.configuration.funnels.indices.forEach { index in
                    self.configuration.funnels[index].update(action: action)

                    if self.configuration.funnels[index].isComplete && !self.configuration.funnels[index].hasSentCompletion {
                        store.update(Complete(target: type(of: self.configuration.funnels[index].action)))
                        store.update(self.configuration.funnels[index].action)
                        self.configuration.funnels[index].hasSentCompletion = true

                    }
                }

            }
        }
    }

}
