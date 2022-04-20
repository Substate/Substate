extension ActionTriggerStep1 {

    public func reject(when constant: @autoclosure @escaping @Sendable () -> Bool?) -> ActionTriggerStep1<Output> {
        ActionTriggerStep1 { action, store in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, store: store) {
                        if constant() != true {
                            continuation.yield(output)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    public func reject(when condition: @escaping @Sendable (Output) -> Bool) -> ActionTriggerStep1<Output> {
        ActionTriggerStep1 { action, store in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, store: store) {
                        if condition(output) != true {
                            continuation.yield(output)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    public func reject(when condition: @escaping @Sendable (Output) -> Bool?) -> ActionTriggerStep1<Output> {
        ActionTriggerStep1 { action, store in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, store: store) {
                        if condition(output) != true {
                            continuation.yield(output)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

}
