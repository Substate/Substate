import Substate

extension ActionTriggerStep2 {

    /// Map an action step.
    ///
    public func map<V1>(_ transform: @escaping (Output1, Output2) -> V1) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
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
    public func compactMap<V1>(_ transform: @escaping (Output1, Output2) -> V1?) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1<V1> { action, find in

            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
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
