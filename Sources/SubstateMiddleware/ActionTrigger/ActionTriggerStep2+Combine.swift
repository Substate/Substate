import Substate

extension ActionTriggerStep2 {

    /// Combine action step with 1 constant value.
    /// 
    public func combine<V1>(with value: @autoclosure @escaping () -> V1) -> ActionTriggerStep3<Output1, Output2, V1> {
        ActionTriggerStep3 { action, find in
            await run(action: action, find: find).map { ($0, $1, value()) }
        }
    }

    /// Combine action step with 1 model.
    ///
    public func combine<M1:Model>(with model: M1.Type) -> ActionTriggerStep3<Output1, Output2, M1> {
        ActionTriggerStep3 { action, find in
            await run(action: action, find: find).flatMap {
                if let m1 = find(model) as? M1 {
                    return ($0, $1, m1)
                } else {
                    return nil
                }
            }
        }
    }

    /// Combine action step with 1 model value.
    /// 
    public func combine<M1:Model, V1>(with modelValue: KeyPath<M1, V1>) -> ActionTriggerStep3<Output1, Output2, V1> {
        ActionTriggerStep3 { action, find in
            await run(action: action, find: find).flatMap {
                if let m1 = find(M1.self) as? M1 {
                    return ($0, $1, m1[keyPath: modelValue])
                } else {
                    return nil
                }
            }
        }
    }

}
