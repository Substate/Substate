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

    public func update(update: @escaping Update, find: @escaping Find) -> (@escaping Update) -> Update {
        return { next in
            return { action in
                if action is Store.Start {
                    update(Self.Start())
                    next(action)
                    return
                }


                next(action)
                // ...

//                if let configuration = store.find(Configuration.self) {
//                  ...
                // TODO: When store supports full recursion, use it for our config here
//                }

                // Extremely clunky, but it’s a start!
                self.configuration.funnels.indices.forEach { index in
                    self.configuration.funnels[index].update(action: action)

                    if self.configuration.funnels[index].isComplete && !self.configuration.funnels[index].hasSentCompletion {
                        update(Complete(target: type(of: self.configuration.funnels[index].action)))
                        update(self.configuration.funnels[index].action)
                        self.configuration.funnels[index].hasSentCompletion = true

                    }
                }

            }
        }
    }

}