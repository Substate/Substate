import Substate

extension ActionTriggerStep1 {
    
    /// Combine action step with 1 constant value.
    ///
    public func combine<V1>(with value: @autoclosure @escaping @Sendable () -> V1) -> ActionTriggerStep2<Output, V1> {
        ActionTriggerStep2 { action, store in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, store: store) {
                        let result = (output, value())
                        continuation.yield(result)
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// Combine action step with 2 constant values.
    ///
    public func combine<V1, V2>(with value1: @autoclosure @escaping @Sendable () -> V1, _ value2: @autoclosure @escaping @Sendable () -> V2) -> ActionTriggerStep3<Output, V1, V2> {
        ActionTriggerStep3 { action, store in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, store: store) {
                        let result = (output, value1(), value2())
                        continuation.yield(result)
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// Combine action step with 1 model.
    ///
    public func combine<M1:Model>(with model: M1.Type) -> ActionTriggerStep2<Output, M1> {
        ActionTriggerStep2 { action, store in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, store: store) {
                        if let m1 = store.find(M1.self) {
                            let result = (output, m1)
                            continuation.yield(result)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// Combine action step with 2 models.
    ///
    public func combine<M1:Model, M2:Model>(with model1: M1.Type, _ model2: M2.Type) -> ActionTriggerStep3<Output, M1, M2> {
        ActionTriggerStep3 { action, store in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, store: store) {
                        if let m1 = store.find(M1.self),
                           let m2 = store.find(M2.self) {
                            let result = (output, m1, m2)
                            continuation.yield(result)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// Combine action step with 1 model value.
    ///
    public func combine<M1:Model, V1>(with modelValue: KeyPath<M1, V1>) -> ActionTriggerStep2<Output, V1> where V1 : Sendable {
        ActionTriggerStep2 { action, store in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, store: store) {
                        if let m1 = store.find(M1.self) {
                            let result = (output, m1[keyPath: modelValue as KeyPath<M1, V1>])
                            continuation.yield(result)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// Combine action step with 2 model values.
    ///
    public func combine<M1:Model, V1, M2:Model, V2>(with modelValue1: KeyPath<M1, V1>, _ modelValue2: KeyPath<M2, V2>) -> ActionTriggerStep3<Output, V1, V2> where V1 : Sendable, V2 : Sendable {
        ActionTriggerStep3 { action, store in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, store: store) {
                        if let m1 = store.find(M1.self),
                           let m2 = store.find(M2.self) {
                            let result = (output, m1[keyPath: modelValue1], m2[keyPath: modelValue2])
                            continuation.yield(result)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

}
