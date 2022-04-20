import Substate

extension ActionTriggerStep2 {

    /// Map an action step.
    ///
    public func map<V1>(_ transform: @escaping @Sendable (Output1, Output2) -> V1) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1 { action, store in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, store: store) {
                        let result = transform(output.0, output.1)
                        continuation.yield(result)
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// Compact map an action step.
    ///
    public func compactMap<V1>(_ transform: @escaping @Sendable (Output1, Output2) -> V1?) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1<V1> { action, store in

            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, store: store) {
                        if let result = transform(output.0, output.1) {
                            continuation.yield(result)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

}
