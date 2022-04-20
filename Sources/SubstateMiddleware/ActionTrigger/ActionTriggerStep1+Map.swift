extension ActionTriggerStep1 {

    /// Map an action step.
    ///
    public func map<V1>(_ transform: @escaping @Sendable (Output) -> V1) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1<V1> { action, store in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, store: store) {
                        let result = transform(output)
                        continuation.yield(result)
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// Map an action step over 2 transforms.
    ///
    public func map<V1, V2>(_ transform1: @escaping @Sendable (Output) -> V1, _ transform2: @escaping @Sendable (Output) -> V2) -> ActionTriggerStep2<V1, V2> {
        ActionTriggerStep2 { action, store in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, store: store) {
                        let result = (transform1(output), transform2(output))
                        continuation.yield(result)
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// Map an action step over 3 transforms.
    ///
    public func map<V1, V2, V3>(_ transform1: @escaping @Sendable (Output) -> V1, _ transform2: @escaping @Sendable (Output) -> V2, _ transform3: @escaping @Sendable (Output) -> V3) -> ActionTriggerStep3<V1, V2, V3> {
        ActionTriggerStep3 { action, store in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, store: store) {
                        let result = (transform1(output), transform2(output), transform3(output))
                        continuation.yield(result)
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// Compact map an action step.
    ///
    public func compactMap<V1>(_ transform: @escaping @Sendable (Output) -> V1?) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1<V1> { action, store in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, store: store) {
                        if let result = transform(output) {
                            continuation.yield(result)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

}
