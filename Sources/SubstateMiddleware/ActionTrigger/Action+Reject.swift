import Substate

extension Action {

    public static func reject(when constant: @autoclosure @escaping () -> Bool?) -> ActionTriggerStep1<Self> {
        ActionTriggerStep1 { action, find in
            AsyncStream { continuation in
                Task {
                    if let action = action as? Self, constant() != true {
                        continuation.yield(action)
                    }

                    continuation.finish()
                }
            }
        }
    }

    public static func reject(when condition: @escaping (Self) -> Bool) -> ActionTriggerStep1<Self> {
        ActionTriggerStep1 { action, find in
            AsyncStream { continuation in
                Task {
                    if let action = action as? Self, condition(action) != true {
                        continuation.yield(action)
                    }

                    continuation.finish()
                }
            }
        }
    }

    public static func reject(when condition: @escaping (Self) -> Bool?) -> ActionTriggerStep1<Self> {
        ActionTriggerStep1 { action, find in
            AsyncStream { continuation in
                Task {
                    if let action = action as? Self, condition(action) != true {
                        continuation.yield(action)
                    }

                    continuation.finish()
                }
            }
        }
    }

}
