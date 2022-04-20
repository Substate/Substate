import Substate

extension Action {

    @MainActor public static func accept(when condition: @escaping (Self) -> Bool) -> ActionTriggerStep1<Self> {
        ActionTriggerStep1 { action, _ in
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

    @MainActor public static func accept(when condition: @escaping (Self) -> Bool?) -> ActionTriggerStep1<Self> {
        ActionTriggerStep1 { action, _ in
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
