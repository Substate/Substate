import Substate

extension ActionTriggerStep1 {
    
    /// Combine action step with 1 constant value.
    ///
    public func combine<V1>(with value: @autoclosure @escaping () -> V1) -> ActionTriggerStep2<Output, V1> {
        ActionTriggerStep2 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
                        let result = (output, value())
                        continuation.yield(result)
                    }
                }

                continuation.finish()
            }
        }
    }

    /// Combine action step with 2 constant values.
    ///
    public func combine<V1, V2>(with value1: @autoclosure @escaping () -> V1, _ value2: @autoclosure @escaping () -> V2) -> ActionTriggerStep3<Output, V1, V2> {
        ActionTriggerStep3 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
                        let result = (output, value1(), value2())
                        continuation.yield(result)
                    }
                }

                continuation.finish()
            }
        }
    }

    /// Combine action step with 1 model.
    ///
    public func combine<M1:Model>(with model: M1.Type) -> ActionTriggerStep2<Output, M1> {
        ActionTriggerStep2 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
                        if let m1 = find(model) as? M1 {
                            let result = (output, m1)
                            continuation.yield(result)
                        }
                    }
                }

                continuation.finish()
            }
        }
    }

    /// Combine action step with 2 models.
    ///
    public func combine<M1:Model, M2:Model>(with model1: M1.Type, _ model2: M2.Type) -> ActionTriggerStep3<Output, M1, M2> {
        ActionTriggerStep3 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
                        if let m1 = find(model1) as? M1,
                           let m2 = find(model2) as? M2 {
                            let result = (output, m1, m2)
                            continuation.yield(result)
                        }
                    }
                }

                continuation.finish()
            }
        }
    }

    /// Combine action step with 1 model value.
    ///
    public func combine<M1:Model, V1>(with modelValue: KeyPath<M1, V1>) -> ActionTriggerStep2<Output, V1> {
        ActionTriggerStep2 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
                        if let m1 = find(M1.self) as? M1 {
                            let result = (output, m1[keyPath: modelValue])
                            continuation.yield(result)
                        }
                    }
                }

                continuation.finish()
            }
        }
    }

    /// Combine action step with 2 model values.
    ///
    public func combine<M1:Model, V1, M2:Model, V2>(with modelValue1: KeyPath<M1, V1>, _ modelValue2: KeyPath<M2, V2>) -> ActionTriggerStep3<Output, V1, V2> {
        ActionTriggerStep3 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
                        if let m1 = find(M1.self) as? M1,
                           let m2 = find(M2.self) as? M2 {
                            let result = (output, m1[keyPath: modelValue1], m2[keyPath: modelValue2])
                            continuation.yield(result)
                        }
                    }
                }

                continuation.finish()
            }
        }
    }

}
