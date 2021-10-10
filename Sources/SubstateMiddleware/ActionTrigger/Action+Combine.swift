import Substate

extension Action {

    /// Combine action with 1 constant value.
    ///
    public static func combine<V1>(with value: @autoclosure @escaping () -> V1) -> ActionTriggerStep2<Self, V1> {
        ActionTriggerStep2 { action, find in
            (action as? Self).map { ($0, value()) }
        }
    }

    /// Combine action with 2 constant values.
    ///
    public static func combine<V1, V2>(with value1: @autoclosure @escaping () -> V1, _ value2: @autoclosure @escaping () -> V2) -> ActionTriggerStep3<Self, V1, V2> {
        ActionTriggerStep3 { action, find in
            (action as? Self).map { ($0, value1(), value2()) }
        }
    }

    /// Combine action with 1 model.
    ///
    public static func combine<M1:Model>(with model: M1.Type) -> ActionTriggerStep2<Self, M1> {
        ActionTriggerStep2 { action, find in
            (action as? Self).flatMap {
                if let m1 = find(model) as? M1 {
                    return ($0, m1)
                } else {
                    return nil
                }
            }
        }
    }

    /// Combine action with 2 models.
    ///
    public static func combine<M1:Model, M2:Model>(with model1: M1.Type, _ model2: M2.Type) -> ActionTriggerStep3<Self, M1, M2> {
        ActionTriggerStep3 { action, find in
            (action as? Self).flatMap {
                if let m1 = find(model1) as? M1,
                   let m2 = find(model2) as? M2 {
                    return ($0, m1, m2)
                } else {
                    return nil
                }
            }
        }
    }

    /// Combine action with 1 model value.
    ///
    public static func combine<M1:Model, V1>(with modelValue: KeyPath<M1, V1>) -> ActionTriggerStep2<Self, V1> {
        ActionTriggerStep2 { action, find in
            (action as? Self).flatMap {
                if let m1 = find(M1.self) as? M1 {
                    return ($0, m1[keyPath: modelValue])
                } else {
                    return nil
                }
            }
        }
    }

    /// Combine action with 2 model values.
    ///
    public static func combine<M1:Model, V1, M2:Model, V2>(with modelValue1: KeyPath<M1, V1>, _ modelValue2: KeyPath<M2, V2>) -> ActionTriggerStep3<Self, V1, V2> {
        ActionTriggerStep3 { action, find in
            (action as? Self).flatMap {
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
