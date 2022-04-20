extension ActionTriggerStep3 {

    public func accept(when constant: @autoclosure @escaping @Sendable () -> Bool?) -> ActionTriggerStep3<Output1, Output2, Output3> {
        ActionTriggerStep3 { action, store in
            AsyncStream { continuation in
                Task {
                    for await value in run(action: action, store: store) {
                        if constant() == true {
                            continuation.yield(value)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    public func accept(when condition: @escaping @Sendable (Output1, Output2, Output3) -> Bool) -> ActionTriggerStep3<Output1, Output2, Output3> {
        ActionTriggerStep3 { action, store in
            AsyncStream { continuation in
                Task {
                    for await value in run(action: action, store: store) {
                        if condition(value.0, value.1, value.2) == true {
                            continuation.yield(value)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    public func accept(when condition: @escaping @Sendable (Output1, Output2, Output3) -> Bool?) -> ActionTriggerStep3<Output1, Output2, Output3> {
        ActionTriggerStep3 { action, store in
            AsyncStream { continuation in
                Task {
                    for await value in run(action: action, store: store) {
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
