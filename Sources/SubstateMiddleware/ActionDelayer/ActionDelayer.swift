import Foundation
import Substate

public class ActionDelayer: Middleware {

    public init() {}

    public static let initialInternalState: Substate.State? = nil

    public func setup(store: Store) {}

    public func update(store: Store) -> (@escaping UpdateFunction) -> UpdateFunction {
        return { next in
            return { action in
                if let delayedAction = action as? DelayedAction {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delayedAction.delay) {
                        next(action)
                    }
                } else {
                    next(action)
                }
            }
        }
    }

}
