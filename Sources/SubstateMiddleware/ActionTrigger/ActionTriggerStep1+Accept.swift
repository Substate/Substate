extension ActionTriggerStep1 {

    public func accept(when constant: @autoclosure @escaping () -> Bool?) -> ActionTriggerStep1<Output> {
        ActionTriggerStep1 { action, find in
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

    public func accept(when condition: @escaping (Output) -> Bool) -> ActionTriggerStep1<Output> {
        ActionTriggerStep1 { action, find in
            AsyncStream { continuation in
                Task {
                    for await value in run(action: action, find: find) {
                        if condition(value) {
                            continuation.yield(value)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    public func accept(when condition: @escaping (Output) -> Bool?) -> ActionTriggerStep1<Output> {
        ActionTriggerStep1 { action, find in
            AsyncStream { continuation in
                Task {
                    for await value in run(action: action, find: find) {
                        if condition(value) == true {
                            continuation.yield(value)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    // New constant variation, accepting an output-typed value.
    // TODO: Add this to the other action steps and test suite.

    public func accept(when constant: @autoclosure @escaping () -> Output) -> ActionTriggerStep1<Output> where Output : Equatable {
        ActionTriggerStep1 { action, find in
            AsyncStream { continuation in
                Task {
                    for await value in run(action: action, find: find) {
                        if constant() == value {
                            continuation.yield(value)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

}
