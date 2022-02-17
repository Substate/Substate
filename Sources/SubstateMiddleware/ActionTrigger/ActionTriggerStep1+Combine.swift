import Substate

extension ActionTriggerStep1 {
    
    /// Combine action step with 1 constant value.
    ///
    public func combine<V1>(with value: @autoclosure @escaping () -> V1) -> ActionTriggerStep2<Output, V1> {
        ActionTriggerStep2 { action, find in
            await run(action: action, find: find).map { ($0, value()) }
        }
    }

    /// Combine action step with 2 constant values.
    ///
    public func combine<V1, V2>(with value1: @autoclosure @escaping () -> V1, _ value2: @autoclosure @escaping () -> V2) -> ActionTriggerStep3<Output, V1, V2> {
        ActionTriggerStep3 { action, find in
            await run(action: action, find: find).map { ($0, value1(), value2()) }
        }
    }

    /// Combine action step with 1 model.
    ///
    public func combine<M1:Model>(with model: M1.Type) -> ActionTriggerStep2<Output, M1> {
        ActionTriggerStep2 { action, find in
            await run(action: action, find: find).flatMap {
                if let m1 = find(model) as? M1 {
                    return ($0, m1)
                } else {
                    return nil
                }
            }
        }
    }

    /// Combine action step with 2 models.
    ///
    public func combine<M1:Model, M2:Model>(with model1: M1.Type, _ model2: M2.Type) -> ActionTriggerStep3<Output, M1, M2> {
        ActionTriggerStep3 { action, find in
            await run(action: action, find: find).flatMap {
                if let m1 = find(model1) as? M1,
                   let m2 = find(model2) as? M2 {
                    return ($0, m1, m2)
                } else {
                    return nil
                }
            }
        }
    }

    /// Combine action step with 1 model value.
    ///
    public func combine<M1:Model, V1>(with modelValue: KeyPath<M1, V1>) -> ActionTriggerStep2<Output, V1> {
        ActionTriggerStep2 { action, find in
            await run(action: action, find: find).flatMap {
                if let m1 = find(M1.self) as? M1 {
                    return ($0, m1[keyPath: modelValue])
                } else {
                    return nil
                }
            }
        }
    }

    /// Combine action step with 2 model values.
    ///
    public func combine<M1:Model, V1, M2:Model, V2>(with modelValue1: KeyPath<M1, V1>, _ modelValue2: KeyPath<M2, V2>) -> ActionTriggerStep3<Output, V1, V2> {
        ActionTriggerStep3 { action, find in
            await run(action: action, find: find).flatMap {
                if let m1 = find(M1.self) as? M1,
                   let m2 = find(M2.self) as? M2 {
                    return ($0, m1[keyPath: modelValue1], m2[keyPath: modelValue2])
                } else {
                    return nil
                }
            }
        }
    }

}
