import Substate

extension ActionTriggerStep3 {

    @available(*, unavailable, message: "Trigger can only be called once the previous step produces an output of type Action")
    public func trigger() {
        fatalError()
    }

    /// Trigger from an action step with a constant action.
    ///
    public func trigger<A1:Action>(_ result: @autoclosure @escaping @Sendable () -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, store in
            AsyncStream { continuation in
                Task {
                    for await _ in run(action: action, store: store) {
                        if let value = result() {
                            continuation.yield(value)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// Trigger from an action step with a function.
    ///
    public func trigger<A1:Action>(_ result: @escaping @Sendable () -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, store in
            AsyncStream { continuation in
                Task {
                    for await _ in run(action: action, store: store) {
                        if let value = result() {
                            continuation.yield(value)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    /// trigger from an action step with a transform.
    ///
    public func trigger<A1:Action>(_ transform: @escaping @Sendable (Output1, Output2, Output3) -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, store in
            AsyncStream { continuation in
                Task {
                    for await value in run(action: action, store: store) {
                        if let result = transform(value.0, value.1, value.2) {
                            continuation.yield(result)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

}
