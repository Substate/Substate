extension ActionTriggerStep1 {

    public func accept(when constant: @autoclosure @escaping () -> Bool?) -> ActionTriggerStep1<Output> {
        ActionTriggerStep1 { action, find in
            await run(action: action, find: find).flatMap { constant() == true ? $0 : nil }
        }
    }

    public func accept(when condition: @escaping (Output) -> Bool) -> ActionTriggerStep1<Output> {
        ActionTriggerStep1 { action, find in
            await run(action: action, find: find).flatMap { condition($0) ? $0 : nil }
        }
    }

    public func accept(when condition: @escaping (Output) -> Bool?) -> ActionTriggerStep1<Output> {
        ActionTriggerStep1 { action, find in
            await run(action: action, find: find).flatMap { condition($0) == true ? $0 : nil }
        }
    }

    // New constant variation, accepting an output-typed value.
    // TODO: Add this to the other action steps and test suite.

    public func accept(when constant: @autoclosure @escaping () -> Output) -> ActionTriggerStep1<Output> where Output : Equatable {
        ActionTriggerStep1 { action, find in
            await run(action: action, find: find).flatMap { constant() == $0 ? $0 : nil }
        }
    }

}
