import Substate

extension ActionTriggerStep2 {

    /// Combine action step with 1 constant value.
    /// 
    public func combine<V1>(with value: @autoclosure @escaping () -> V1) -> ActionTriggerStep3<Output1, Output2, V1> {
        ActionTriggerStep3 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
                        continuation.yield((output.0, output.1, value()))
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// Combine action step with 1 model.
    ///
    public func combine<M1:Model>(with model: M1.Type) -> ActionTriggerStep3<Output1, Output2, M1> {
        ActionTriggerStep3 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
                        if let m1 = find(model) as? M1 {
                            continuation.yield((output.0, output.1, m1))
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// Combine action step with 1 model value.
    /// 
    public func combine<M1:Model, V1>(with modelValue: KeyPath<M1, V1>) -> ActionTriggerStep3<Output1, Output2, V1> {
        ActionTriggerStep3 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
                        if let m1 = find(M1.self) as? M1 {
                            continuation.yield((output.0, output.1, m1[keyPath: modelValue]))
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

}
