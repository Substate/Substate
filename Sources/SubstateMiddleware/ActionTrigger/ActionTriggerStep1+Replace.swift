import Substate

extension ActionTriggerStep1 {

    /// Replace action step with 1 constant value.
    ///
    public func replace<V1>(with value: @autoclosure @escaping () -> V1) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1<V1> { action, find in
            AsyncStream { continuation in
                Task {
                    for await _ in run(action: action, find: find) {
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
    public func replace<V1, V2>(with value1: @autoclosure @escaping () -> V1, _ value2: @autoclosure @escaping () -> V2) -> ActionTriggerStep2<V1, V2> {
        ActionTriggerStep2 { action, find in
            AsyncStream { continuation in
                Task {
                    for await _ in run(action: action, find: find) {
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
    public func replace<V1, V2, V3>(with value1: @autoclosure @escaping () -> V1, _ value2: @autoclosure @escaping () -> V2, _ value3: @autoclosure @escaping () -> V3) -> ActionTriggerStep3<V1, V2, V3> {
        ActionTriggerStep3 { action, find in
            AsyncStream { continuation in
                Task {
                    for await _ in run(action: action, find: find) {
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
        ActionTriggerStep1<M1> { action, find in
            AsyncStream { continuation in
                Task {
                    for await _ in run(action: action, find: find) {
                        if let m1 = find(model) as? M1 {
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
        ActionTriggerStep2 { action, find in
            AsyncStream { continuation in
                Task {
                    for await _ in run(action: action, find: find) {
                        if let m1 = find(model1) as? M1,
                           let m2 = find(model2) as? M2 {
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
        ActionTriggerStep3 { action, find in
            AsyncStream { continuation in
                Task {
                    for await _ in run(action: action, find: find) {
                        if let m1 = find(model1) as? M1,
                           let m2 = find(model2) as? M2,
                           let m3 = find(model3) as? M3 {
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
    public func replace<M1:Model, V1>(with modelValue: KeyPath<M1, V1>) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1<V1> { action, find in
            AsyncStream { continuation in
                Task {
                    for await _ in run(action: action, find: find) {
                        if let m1 = find(M1.self) as? M1 {
                            let result = m1[keyPath: modelValue]
                            continuation.yield(result)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// Replace action step with 2 model values.
    ///
    public func replace<M1:Model, V1, M2:Model, V2>(with modelValue1: KeyPath<M1, V1>, _ modelValue2: KeyPath<M2, V2>) -> ActionTriggerStep2<V1, V2> {
        ActionTriggerStep2 { action, find in
            AsyncStream { continuation in
                Task {
                    for await _ in run(action: action, find: find) {
                        if let m1 = find(M1.self) as? M1,
                           let m2 = find(M2.self) as? M2 {
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
    public func replace<M1:Model, V1, M2:Model, V2, M3:Model, V3>(with modelValue1: KeyPath<M1, V1>, _ modelValue2: KeyPath<M2, V2>, _ modelValue3: KeyPath<M3, V3>) -> ActionTriggerStep3<V1, V2, V3> {
        ActionTriggerStep3 { action, find in
            AsyncStream { continuation in
                Task {
                    for await _ in run(action: action, find: find) {
                        if let m1 = find(M1.self) as? M1,
                           let m2 = find(M2.self) as? M2,
                           let m3 = find(M3.self) as? M3 {
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
