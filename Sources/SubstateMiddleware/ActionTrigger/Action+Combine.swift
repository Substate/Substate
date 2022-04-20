import Substate

extension Action {

    /// Combine action with 1 constant value.
    ///
    @MainActor public static func combine<V1>(with value: @autoclosure @escaping () -> V1) -> ActionTriggerStep2<Self, V1> {
        ActionTriggerStep2 { action, _ in
            AsyncStream { continuation in
                if let action = action as? Self {
                    let result = (action, value())
                    continuation.yield(result)
                }

                continuation.finish()
            }
        }
    }

    /// Combine action with 2 constant values.
    ///
    @MainActor public static func combine<V1, V2>(with value1: @autoclosure @escaping () -> V1, _ value2: @autoclosure @escaping () -> V2) -> ActionTriggerStep3<Self, V1, V2> {
        ActionTriggerStep3 { action, _ in
            AsyncStream { continuation in
                if let action = action as? Self {
                    let result = (action, value1(), value2())
                    continuation.yield(result)
                }

                continuation.finish()
            }
        }
    }

    /// Combine action with 1 model.
    ///
    @MainActor public static func combine<M1:Model>(with model: M1.Type) -> ActionTriggerStep2<Self, M1> {
        ActionTriggerStep2 { action, store in
            AsyncStream { continuation in
                if let action = action as? Self {
                    if let m1 = store.find(M1.self) {
                        let result = (action, m1)
                        continuation.yield(result)
                    }
                }

                continuation.finish()
            }
        }
    }

    /// Combine action with 2 models.
    ///
    @MainActor public static func combine<M1:Model, M2:Model>(with model1: M1.Type, _ model2: M2.Type) -> ActionTriggerStep3<Self, M1, M2> {
        ActionTriggerStep3 { action, store in
            AsyncStream { continuation in
                if let action = action as? Self {
                    if let m1 = store.find(M1.self),
                       let m2 = store.find(M2.self) {
                        let result = (action, m1, m2)
                        continuation.yield(result)
                    }
                }

                continuation.finish()
            }
        }
    }

    /// Combine action with 1 model value.
    ///
    @MainActor public static func combine<M1:Model, V1>(with modelValue: KeyPath<M1, V1>) -> ActionTriggerStep2<Self, V1> {
        ActionTriggerStep2 { action, store in
            AsyncStream { continuation in
                if let action = action as? Self {
                    if let m1 = store.find(M1.self) {
                        let v1 = m1[keyPath: modelValue]
                        continuation.yield((action, v1))
                    }
                }

                continuation.finish()
            }
        }
    }

    /// Combine action with 2 model values.
    ///
    @MainActor public static func combine<M1:Model, V1, M2:Model, V2>(with modelValue1: KeyPath<M1, V1>, _ modelValue2: KeyPath<M2, V2>) -> ActionTriggerStep3<Self, V1, V2> {
        ActionTriggerStep3 { action, store in
            AsyncStream { continuation in
                if let action = action as? Self {
                    if let m1 = store.find(M1.self),
                       let m2 = store.find(M2.self) {
                        let v1 = m1[keyPath: modelValue1]
                        let v2 = m2[keyPath: modelValue2]
                        continuation.yield((action, v1, v2))
                    }
                }

                continuation.finish()
            }
        }
    }

}
