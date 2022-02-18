extension ActionTriggerStep2 {

    public func reject(when constant: @autoclosure @escaping () -> Bool?) -> ActionTriggerStep2<Output1, Output2> {
        ActionTriggerStep2 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
                        if constant() == true {
                            continuation.yield((output.0, output.1))
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    public func reject(when condition: @escaping (Output1, Output2) -> Bool) -> ActionTriggerStep2<Output1, Output2> {
        ActionTriggerStep2 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
                        if condition(output.0, output.1) == true {
                            continuation.yield((output.0, output.1))
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    public func reject(when condition: @escaping (Output1, Output2) -> Bool?) -> ActionTriggerStep2<Output1, Output2> {
        ActionTriggerStep2 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
                        if condition(output.0, output.1) == true {
                            continuation.yield((output.0, output.1))
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

}
