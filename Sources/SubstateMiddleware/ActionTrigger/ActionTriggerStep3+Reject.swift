extension ActionTriggerStep3 {

    public func reject(when constant: @autoclosure @escaping () -> Bool?) -> ActionTriggerStep3<Output1, Output2, Output3> {
        ActionTriggerStep3 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
                        if constant() != true {
                            continuation.yield(output)
                        }
                    }
                }

                continuation.finish()
            }
        }
    }

    public func reject(when condition: @escaping (Output1, Output2, Output3) -> Bool) -> ActionTriggerStep3<Output1, Output2, Output3> {
        ActionTriggerStep3 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
                        if condition(output.0, output.1, output.2) != true {
                            continuation.yield(output)
                        }
                    }
                }

                continuation.finish()
            }
        }
    }

    public func reject(when condition: @escaping (Output1, Output2, Output3) -> Bool?) -> ActionTriggerStep3<Output1, Output2, Output3> {
        ActionTriggerStep3 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
                        if condition(output.0, output.1, output.2) != true {
                            continuation.yield(output)
                        }
                    }
                }

                continuation.finish()
            }
        }
    }

}
