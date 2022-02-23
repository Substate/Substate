import Substate

extension ActionTriggerStep1 {

    @available(*, unavailable, message: "Trigger can only be called once the previous step produces an output of type Action")
    public func trigger() {
        fatalError()
    }

    /// Trigger from an action step with a constant action.
    ///
    public func trigger<A1:Action>(_ result: @autoclosure @escaping () -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, find in
            AsyncStream { continuation in
                Task {
                    for await _ in run(action: action, find: find) {
                        if let output = result() {
                            continuation.yield(output)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// Trigger from an action step with a function.
    ///
    public func trigger<A1:Action>(_ result: @escaping () -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, find in
            AsyncStream { continuation in
                Task {
                    for await _ in run(action: action, find: find) {
                        if let output = result() {
                            continuation.yield(output)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// Trigger from an action step with a transform.
    ///
    public func trigger<A1:Action>(_ transform: @escaping (Output) -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, find in
            AsyncStream { continuation in
                Task {
                    for await value in run(action: action, find: find) {
                        if let output = transform(value) {
                            continuation.yield(output)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

}

extension ActionTriggerStep1 where Output: Action {

    public func trigger() -> ActionTriggerStepFinal<Output> {
        ActionTriggerStepFinal { action, find in
            run(action: action, find: find)
        }
    }

}
