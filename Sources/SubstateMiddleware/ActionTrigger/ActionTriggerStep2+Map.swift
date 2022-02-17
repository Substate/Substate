import Substate

extension ActionTriggerStep2 {

    /// Map an action step.
    ///
    public func map<V1>(_ transform: @escaping (Output1, Output2) -> V1) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1 { action, find in
            await run(action: action, find: find).map(transform)
        }
    }

    /// Compact map an action step.
    ///
    public func compactMap<V1>(_ transform: @escaping (Output1, Output2) -> V1?) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1<V1> { action, find in
            await run(action: action, find: find).flatMap(transform)
        }
    }

}
