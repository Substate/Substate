extension ActionTriggerStep1 {

    @MainActor public func accept(when condition: @escaping @Sendable (Output) -> Bool) -> ActionTriggerStep1<Output> {
        ActionTriggerStep1 { action, store in
            AsyncStream { continuation in
                Task {
                    for await value in run(action: action, store: store) {
                        if condition(value) {
                            continuation.yield(value)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    @MainActor public func accept(when condition: @escaping @Sendable (Output) -> Bool?) -> ActionTriggerStep1<Output> {
        ActionTriggerStep1 { action, store in
            AsyncStream { continuation in
                Task {
                    for await value in run(action: action, store: store) {
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

    @MainActor public func accept(when constant: @autoclosure @escaping @Sendable () -> Output) -> ActionTriggerStep1<Output> where Output : Equatable {
        ActionTriggerStep1 { action, store in
            AsyncStream { continuation in
                Task {
                    for await value in run(action: action, store: store) {
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
