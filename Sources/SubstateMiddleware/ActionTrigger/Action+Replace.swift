import Substate

extension Action {

    /// Replace action with 1 constant value.
    ///
    public static func replace<V1>(with value: @autoclosure @escaping () -> V1) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1 { action, find in
            (action as? Self).map { _ in value() }
        }
    }

    /// Replace action with 2 constant values.
    ///
    public static func replace<V1, V2>(with value1: @autoclosure @escaping () -> V1, _ value2: @autoclosure @escaping () -> V2) -> ActionTriggerStep2<V1, V2> {
        ActionTriggerStep2 { action, find in
            (action as? Self).map { _ in (value1(), value2()) }
        }
    }

    /// Replace action with 3 constant values.
    ///
    public static func replace<V1, V2, V3>(with value1: @autoclosure @escaping () -> V1, _ value2: @autoclosure @escaping () -> V2, _ value3: @autoclosure @escaping () -> V3) -> ActionTriggerStep3<V1, V2, V3> {
        ActionTriggerStep3 { action, find in
            (action as? Self).map { _ in (value1(), value2(), value3()) }
        }
    }

    /// Replace action with 1 model.
    ///
    public static func replace<M1:Model>(with model: M1.Type) -> ActionTriggerStep1<M1> {
        ActionTriggerStep1 { action, find in
            (action as? Self).flatMap { _ in find(model) as? M1 }
        }
    }

    /// Replace action with 2 models.
    ///
    public static func replace<M1:Model, M2:Model>(with model1: M1.Type, _ model2: M2.Type) -> ActionTriggerStep2<M1, M2> {
        ActionTriggerStep2 { action, find in
            (action as? Self).flatMap { _ in
                if let m1 = find(model1) as? M1,
                   let m2 = find(model2) as? M2 {
                    return (m1, m2)
                } else {
                    return nil
                }
            }
        }
    }

    /// Replace action with 3 models.
    ///
    public static func replace<M1:Model, M2:Model, M3:Model>(with model1: M1.Type, _ model2: M2.Type, _ model3: M3.Type) -> ActionTriggerStep3<M1, M2, M3> {
        ActionTriggerStep3 { action, find in
            (action as? Self).flatMap { _ in
                if let m1 = find(model1) as? M1,
                   let m2 = find(model2) as? M2,
                   let m3 = find(model3) as? M3 {
                    return (m1, m2, m3)
                } else {
                    return nil
                }
            }
        }
    }

    /// Replace action with 1 model value.
    ///
    public static func replace<M1:Model, V1>(with modelValue: KeyPath<M1, V1>) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1 { action, find in
            (action as? Self)
                .flatMap { _ in find(M1.self) as? M1 }
                .map { $0[keyPath: modelValue] }
        }
    }

    /// Replace action with 2 model values.
    ///
    public static func replace<M1:Model, V1, M2:Model, V2>(with modelValue1: KeyPath<M1, V1>, _ modelValue2: KeyPath<M2, V2>) -> ActionTriggerStep2<V1, V2> {
        ActionTriggerStep2 { action, find in
            (action as? Self)
                .flatMap { _ -> (M1, M2)? in
                    if let m1 = find(M1.self) as? M1,
                       let m2 = find(M2.self) as? M2 {
                        return (m1, m2)
                    } else {
                        return nil
                    }
                }
                .map {
                    ($0[keyPath: modelValue1], $1[keyPath: modelValue2])
                }
        }
    }

    /// Replace action with 3 model values.
    ///
    public static func replace<M1:Model, V1, M2:Model, V2, M3:Model, V3>(with modelValue1: KeyPath<M1, V1>, _ modelValue2: KeyPath<M2, V2>, _ modelValue3: KeyPath<M3, V3>) -> ActionTriggerStep3<V1, V2, V3> {
        ActionTriggerStep3 { action, find in
            (action as? Self)
                .flatMap { _ -> (M1, M2, M3)? in
                    if let m1 = find(M1.self) as? M1,
                       let m2 = find(M2.self) as? M2,
                       let m3 = find(M3.self) as? M3 {
                        return (m1, m2, m3)
                    } else {
                        return nil
                    }
                }
                .map {
                    ($0[keyPath: modelValue1], $1[keyPath: modelValue2], $2[keyPath: modelValue3])
                }
        }
    }

}
