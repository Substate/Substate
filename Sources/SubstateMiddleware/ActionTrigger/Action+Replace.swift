import Substate

extension Action {

    /// Replace action with 1 constant value.
    ///
    @MainActor public static func replace<V1>(with value: @autoclosure @escaping () -> V1) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1 { action, _ in
            AsyncStream { continuation in
                if action is Self {
                    continuation.yield(value())
                }

                continuation.finish()
            }
        }
    }

    /// Replace action with 2 constant values.
    ///
    @MainActor public static func replace<V1, V2>(with value1: @autoclosure @escaping () -> V1, _ value2: @autoclosure @escaping () -> V2) -> ActionTriggerStep2<V1, V2> {
        ActionTriggerStep2 { action, _ in
            AsyncStream { continuation in
                if action is Self {
                    continuation.yield((value1(), value2()))
                }

                continuation.finish()
            }
        }
    }

    /// Replace action with 3 constant values.
    ///
    @MainActor public static func replace<V1, V2, V3>(with value1: @autoclosure @escaping () -> V1, _ value2: @autoclosure @escaping () -> V2, _ value3: @autoclosure @escaping () -> V3) -> ActionTriggerStep3<V1, V2, V3> {
        ActionTriggerStep3 { action, _ in
            AsyncStream { continuation in
                if action is Self {
                    continuation.yield((value1(), value2(), value3()))
                }

                continuation.finish()
            }
        }
    }

    /// Replace action using a closure.
    ///
    @MainActor public static func replace<V1>(with closure: @escaping () -> V1) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1 { action, _ in
            AsyncStream { continuation in
                if action is Self {
                    continuation.yield(closure())
                }

                continuation.finish()
            }
        }
    }

    /// Replace action with 1 model.
    ///
    @MainActor public static func replace<M1:Model>(with model: M1.Type) -> ActionTriggerStep1<M1> {
        ActionTriggerStep1 { action, store in
            AsyncStream { continuation in
                if action is Self {
                    if let m1 = store.find(M1.self) {
                        continuation.yield(m1)
                    }
                }

                continuation.finish()
            }
        }
    }

    /// Replace action with 2 models.
    ///
    @MainActor public static func replace<M1:Model, M2:Model>(with model1: M1.Type, _ model2: M2.Type) -> ActionTriggerStep2<M1, M2> {
        ActionTriggerStep2 { action, store in
            AsyncStream { continuation in
                if action is Self {
                    if let m1 = store.find(M1.self),
                       let m2 = store.find(M2.self) {
                        continuation.yield((m1, m2))
                    }
                }

                continuation.finish()
            }
        }
    }

    /// Replace action with 3 models.
    ///
    @MainActor public static func replace<M1:Model, M2:Model, M3:Model>(with model1: M1.Type, _ model2: M2.Type, _ model3: M3.Type) -> ActionTriggerStep3<M1, M2, M3> {
        ActionTriggerStep3 { action, store in
            AsyncStream { continuation in
                if action is Self {
                    if let m1 = store.find(M1.self),
                       let m2 = store.find(M2.self),
                       let m3 = store.find(M3.self) {
                        continuation.yield((m1, m2, m3))
                    }
                }

                continuation.finish()
            }
        }
    }

    /// Replace action with 1 model value.
    ///
    @MainActor public static func replace<M1:Model, V1>(with modelValue: KeyPath<M1, V1>) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1 { action, store in
            AsyncStream { continuation in
                if action is Self {
                    if let m1 = store.find(M1.self) {
                        let result = m1[keyPath: modelValue]
                        continuation.yield(result)
                    }
                }

                continuation.finish()
            }
        }
    }

    /// Replace action with 2 model values.
    ///
    @MainActor public static func replace<M1:Model, V1, M2:Model, V2>(with modelValue1: KeyPath<M1, V1>, _ modelValue2: KeyPath<M2, V2>) -> ActionTriggerStep2<V1, V2> {
        ActionTriggerStep2 { action, store in
            AsyncStream { continuation in
                if action is Self {
                    if let m1 = store.find(M1.self),
                       let m2 = store.find(M2.self) {
                        let v1 = m1[keyPath: modelValue1]
                        let v2 = m2[keyPath: modelValue2]
                        continuation.yield((v1, v2))
                    }
                }

                continuation.finish()
            }
        }
    }

    /// Replace action with 3 model values.
    ///
    @MainActor public static func replace<M1:Model, V1, M2:Model, V2, M3:Model, V3>(with modelValue1: KeyPath<M1, V1>, _ modelValue2: KeyPath<M2, V2>, _ modelValue3: KeyPath<M3, V3>) -> ActionTriggerStep3<V1, V2, V3> {
        ActionTriggerStep3 { action, store in
            AsyncStream { continuation in
                if action is Self {
                    if let m1 = store.find(M1.self),
                       let m2 = store.find(M2.self),
                       let m3 = store.find(M3.self) {
                        let v1 = m1[keyPath: modelValue1]
                        let v2 = m2[keyPath: modelValue2]
                        let v3 = m3[keyPath: modelValue3]
                        continuation.yield((v1, v2, v3))
                    }
                }

                continuation.finish()
            }
        }
    }

}
