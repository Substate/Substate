import Substate

extension ActionTriggerStep3 {

    @available(*, unavailable, message: "Trigger can only be called once the previous step produces an output of type Action")
    public func trigger() {
        fatalError()
    }

    /// Trigger from an action step with a constant action.
    ///
    public func trigger<A1:Action>(_ result: @autoclosure @escaping () -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, find in
            await run(action: action, find: find).flatMap { _, _, _ in result() }
        }
    }

    /// Trigger from an action step with a function.
    ///
    public func trigger<A1:Action>(_ result: @escaping () -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, find in
            await run(action: action, find: find).flatMap { _ in result() }
        }
    }

    /// trigger from an action step with a transform.
    ///
    public func trigger<A1:Action>(_ transform: @escaping (Output1, Output2, Output3) -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, find in
            await run(action: action, find: find).flatMap(transform)
        }
    }

}
