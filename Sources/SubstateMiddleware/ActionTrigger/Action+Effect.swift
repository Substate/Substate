import Substate

extension Action {

    /// Perform a side effect ignoring the action.
    ///
    /// - Action1.peform { service.doSomething() }
    /// - Action1.peform { await service.doSomething() }
    /// - Action1.peform { try await service.doSomething() }
    ///
    public static func perform<V1>(_ effect: @escaping () async throws -> V1) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1 { action, find in
            if action is Self, let value = try? await effect() {
                return value
            } else {
                return nil
            }
        }
    }

}

