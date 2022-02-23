import Substate

extension Action {

    /// Perform a side effect, ignoring the action.
    ///
    /// - Action1.peform { service.doSomething() }
    /// - Action1.peform { await service.doSomething() }
    /// - Action1.peform { try await service.doSomething() }
    ///
    public static func perform<V1>(_ effect: @escaping () async throws -> V1) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1 { action, find in
            AsyncStream { continuation in
                Task {
                    if action is Self {
                        if let result = try? await effect() {
                            continuation.yield(result)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    public static func perform(_ effect: @escaping () async throws -> Void) -> ActionTriggerStepFinal<VoidAction> {
        ActionTriggerStepFinal { action, find in
            AsyncStream { continuation in
                Task {
                    if action is Self {
                        try? await effect()
                        continuation.yield(VoidAction())
                    }

                    continuation.finish()
                }
            }
        }
    }

    public static func perform<V1>(_ effect: @escaping (Self) async throws -> V1) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1 { action, find in
            AsyncStream { continuation in
                Task {
                    if let action = action as? Self {
                        if let result = try? await effect(action) {
                            continuation.yield(result)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    public static func perform(_ effect: @escaping (Self) async throws -> Void) -> ActionTriggerStepFinal<VoidAction> {
        ActionTriggerStepFinal { action, find in
            AsyncStream { continuation in
                Task {
                    if let action = action as? Self {
                        try? await effect(action)
                        continuation.yield(VoidAction())
                    }
                    
                    continuation.finish()
                }
            }
        }
    }

}
public struct VoidAction:Action{}
