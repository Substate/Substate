import Substate

extension Action {

    /// Accept an action by boolean.
    ///
    public static func accept(when constant: @autoclosure @escaping () -> Bool?) -> ActionTriggerStep1<Self> {
        ActionTriggerStep1 { action, find in
            AsyncStream { continuation in
                if let action = action as? Self {
                    if constant() == true {
                        continuation.yield(action)
                    }
                }

                continuation.finish()
            }
        }
    }

    public static func accept(when condition: @escaping (Self) -> Bool) -> ActionTriggerStep1<Self> {
        ActionTriggerStep1 { action, find in
            AsyncStream { continuation in
                if let action = action as? Self {
                    if condition(action) == true {
                        continuation.yield(action)
                    }
                }

                continuation.finish()
            }
        }
    }

    public static func accept(when condition: @escaping (Self) -> Bool?) -> ActionTriggerStep1<Self> {
        ActionTriggerStep1 { action, find in
            AsyncStream { continuation in
                if let action = action as? Self {
                    if condition(action) == true {
                        continuation.yield(action)
                    }
                }

                continuation.finish()
            }
        }
    }

}
