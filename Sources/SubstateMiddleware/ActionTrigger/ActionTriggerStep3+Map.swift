extension ActionTriggerStep3 {

    /// Map an action step.
    ///
    public func map<V1>(_ transform: @escaping @Sendable (Output1, Output2, Output3) -> V1) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1 { action, store in
            AsyncStream { continuation in
                Task {
                    for await value in run(action: action, store: store) {
                        let result = transform(value.0, value.1, value.2)
                        continuation.yield(result)
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// Compact map an action step.
    ///
    public func compactMap<V1>(_ transform: @escaping @Sendable (Output1, Output2, Output3) -> V1?) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1<V1> { action, store in
            AsyncStream { continuation in
                Task {
                    for await value in run(action: action, store: store) {
                        if let result = transform(value.0, value.1, value.2) {
                            continuation.yield(result)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

}
