import Foundation
import Substate

public class ActionDelayer: Middleware {

    public init() {}

    public func configure(store: Store) -> (@escaping DispatchFunction) -> DispatchFunction {
        { next in
            { action in
                if let delayedAction = action as? DelayedAction {
                    // TODO: Dispatch an action instead of printing here
                    self.output(message: self.description(for: delayedAction))
                    let nanoseconds = UInt64(delayedAction.delay * TimeInterval(NSEC_PER_SEC))

                    Task {
                        try await Task.sleep(nanoseconds: nanoseconds)
                        if !Task.isCancelled {
                            // TODO: We’re losing the ability to test this action as it disappears into the task here
                            // TODO: We also lose any resulting errors
                            try await next(action)
                        }
                    }
                } else {
                    try await next(action)
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
