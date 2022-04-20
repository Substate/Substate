import Substate

extension ActionTriggerStep3 {

    /// Replace action step with 1 constant value.
    ///
    public func replace<V1>(with value: @autoclosure @escaping @Sendable () -> V1) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1<V1> { action, store in
            AsyncStream { continuation in
                Task {
                    for await _ in run(action: action, store: store) {
                        let result = value()
                        continuation.yield(result)
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// Replace action step with 2 constant values.
    ///
    public func replace<V1, V2>(with value1: @autoclosure @escaping @Sendable () -> V1, _ value2: @autoclosure @escaping @Sendable () -> V2) -> ActionTriggerStep2<V1, V2> {
        ActionTriggerStep2 { action, store in
            AsyncStream { continuation in
                Task {
                    for await _ in run(action: action, store: store) {
                        let result = (value1(), value2())
                        continuation.yield(result)
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// Replace action step with 3 constant values.
    ///
    public func replace<V1, V2, V3>(with value1: @autoclosure @escaping @Sendable () -> V1, _ value2: @autoclosure @escaping @Sendable () -> V2, _ value3: @autoclosure @escaping @Sendable () -> V3) -> ActionTriggerStep3<V1, V2, V3> {
        ActionTriggerStep3<V1, V2, V3> { action, store in
            AsyncStream { continuation in
                Task {
                    for await _ in run(action: action, store: store) {
                        let result = (value1(), value2(), value3())
                        continuation.yield(result)
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// Replace action step with 1 model.
    ///
    public func replace<M1:Model>(with model: M1.Type) -> ActionTriggerStep1<M1> {
        ActionTriggerStep1<M1> { action, store in
            AsyncStream { continuation in
                Task {
                    for await _ in run(action: action, store: store) {
                        if let m1 = store.find(M1.self) {
                            continuation.yield(m1)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// Replace action step with 2 models.
    ///
    public func replace<M1:Model, M2:Model>(with model1: M1.Type, _ model2: M2.Type) -> ActionTriggerStep2<M1, M2> {
        ActionTriggerStep2 { action, store in
            AsyncStream { continuation in
                Task {
                    for await _ in run(action: action, store: store) {
                        if let m1 = store.find(M1.self),
                           let m2 = store.find(M2.self) {
                            continuation.yield((m1, m2))
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// Replace action step with 3 models.
    ///
    public func replace<M1:Model, M2:Model, M3:Model>(with model1: M1.Type, _ model2: M2.Type, _ model3: M3.Type) -> ActionTriggerStep3<M1, M2, M3> {
        ActionTriggerStep3<M1, M2, M3> { action, store in
            AsyncStream { continuation in
                Task {
                    for await _ in run(action: action, store: store) {
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
    }

    /// Replace action step with 1 model value.
    ///
    public func replace<M1:Model, V1>(with modelValue: KeyPath<M1, V1>) -> ActionTriggerStep1<V1> where V1 : Sendable {
        ActionTriggerStep1<V1> { action, store in
            AsyncStream { continuation in
                Task {
                    for await _ in run(action: action, store: store) {
                        if let m1 = store.find(M1.self) {
                            let v1 = m1[keyPath: modelValue]
                            continuation.yield(v1)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// Replace action step with 2 model values.
    ///
    public func replace<M1:Model, V1, M2:Model, V2>(with modelValue1: KeyPath<M1, V1>, _ modelValue2: KeyPath<M2, V2>) -> ActionTriggerStep2<V1, V2> where V1 : Sendable, V2 : Sendable {
        ActionTriggerStep2 { action, store in
            AsyncStream { continuation in
                Task {
                    for await _ in run(action: action, store: store) {
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
    }

    /// Replace action step with 3 model values.
    ///
    public func replace<M1:Model, V1, M2:Model, V2, M3:Model, V3>(with modelValue1: KeyPath<M1, V1>, _ modelValue2: KeyPath<M2, V2>, _ modelValue3: KeyPath<M3, V3>) -> ActionTriggerStep3<V1, V2, V3> where V1 : Sendable, V2 : Sendable, V3 : Sendable {
        ActionTriggerStep3<V1, V2, V3> { action, store in
            AsyncStream { continuation in
                Task {
                    for await _ in run(action: action, store: store) {
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

}
