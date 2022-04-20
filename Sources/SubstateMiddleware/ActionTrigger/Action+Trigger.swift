import Substate

extension Action {

    @available(*, unavailable, message: "An action can’t trigger itself because that would (probably) cause an infinite loop!")
    public static func trigger() {
        fatalError()
    }

    /// Trigger from an action with a constant action.
    ///
    /// - Action1.trigger(<Action2>)
    /// - Action1.trigger(<Action2?>)
    ///
    @MainActor public static func trigger<A1:Action>(_ result: @autoclosure @escaping () -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, _ in
            AsyncStream { continuation in
                if action is Self, let output = result() {
                    continuation.yield(output)
                }

                continuation.finish()
            }
        }
    }

    /// Trigger from an action with a function.
    ///
    /// - Action1.trigger { <Action2> }
    /// - Action1.trigger { <Action2?> }
    ///
    @MainActor public static func trigger<A1:Action>(_ result: @escaping () -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, _ in
            AsyncStream { continuation in
                if action is Self, let output = result() {
                    continuation.yield(output)
                }

                continuation.finish()
            }
        }
    }

    /// Trigger from an action with a transform.
    ///
    /// - Action1.trigger { (a: Action1) in <Action2> }
    /// - Action1.trigger { (a: Action1) in <Action2?> }
    ///
    @MainActor public static func trigger<A1:Action>(_ result: @escaping (Self) -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, _ in
            AsyncStream { continuation in
                if let action = action as? Self, let output = result(action) {
                    continuation.yield(output)
                }

                continuation.finish()
            }
        }
    }

}
