extension ActionTriggerStep1 {

    public func reject(when constant: @autoclosure @escaping () -> Bool?) -> ActionTriggerStep1<Output> {
        ActionTriggerStep1 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
                        if constant() != true {
                            continuation.yield(output)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    public func reject(when condition: @escaping (Output) -> Bool) -> ActionTriggerStep1<Output> {
        ActionTriggerStep1 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
                        if condition(output) != true {
                            continuation.yield(output)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    public func reject(when condition: @escaping (Output) -> Bool?) -> ActionTriggerStep1<Output> {
        ActionTriggerStep1 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
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
