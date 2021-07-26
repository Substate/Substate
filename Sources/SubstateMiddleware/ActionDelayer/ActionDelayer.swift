import Foundation
import Substate

public class ActionDelayer: Middleware {

    public init() {}

    public let model: Substate.Model? = nil

    public func setup(store: Store) {}

    public func update(store: Store) -> (@escaping Update) -> Update {
        return { next in
            return { action in
                // TODO: We don’t need to capture self here!
                if let delayedAction = action as? DelayedAction {
                    self.output(message: self.description(for: delayedAction))
                    // TODO: Use a private serial queue
                    DispatchQueue.main.asyncAfter(deadline: .now() + delayedAction.delay) {
                        next(action)
                    }
                } else {
                    next(action)
                }
            }
        }
    }

    private func description(for action: DelayedAction) -> String {
        "- Substate.ActionDelayer: Queuing \(type(of: action)) for \(action.delay)s"
    }

    private func output(message: String) {
        print(message) // TODO: Use some kind of more general shared logger
    }

}
