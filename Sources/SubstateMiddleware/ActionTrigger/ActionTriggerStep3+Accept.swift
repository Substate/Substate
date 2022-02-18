extension ActionTriggerStep3 {

    public func accept(when constant: @autoclosure @escaping () -> Bool?) -> ActionTriggerStep3<Output1, Output2, Output3> {
        ActionTriggerStep3 { action, find in
            AsyncStream { continuation in
                Task {
                    for await value in run(action: action, find: find) {
                        if constant() == true {
                            continuation.yield(value)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    public func accept(when condition: @escaping (Output1, Output2, Output3) -> Bool) -> ActionTriggerStep3<Output1, Output2, Output3> {
        ActionTriggerStep3 { action, find in
            AsyncStream { continuation in
                Task {
                    for await value in run(action: action, find: find) {
                        if condition(value.0, value.1, value.2) == true {
                            continuation.yield(value)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    public func accept(when condition: @escaping (Output1, Output2, Output3) -> Bool?) -> ActionTriggerStep3<Output1, Output2, Output3> {
        ActionTriggerStep3 { action, find in
            AsyncStream { continuation in
                Task {
                    for await value in run(action: action, find: find) {
                        if condition(value.0, value.1, value.2) == true {
                            continuation.yield(value)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

}
