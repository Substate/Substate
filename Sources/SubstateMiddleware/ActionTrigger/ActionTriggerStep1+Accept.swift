extension ActionTriggerStep1 {

    public func accept(when constant: @autoclosure @escaping () -> Bool?) -> ActionTriggerStep1<Output> {
        ActionTriggerStep1 { action, find in
            run(action: action, find: find).flatMap { constant() == true ? $0 : nil }
        }
    }

    public func accept(when condition: @escaping (Output) -> Bool) -> ActionTriggerStep1<Output> {
        ActionTriggerStep1 { action, find in
            run(action: action, find: find).flatMap { condition($0) ? $0 : nil }
        }
    }

    public func accept(when condition: @escaping (Output) -> Bool?) -> ActionTriggerStep1<Output> {
        ActionTriggerStep1 { action, find in
            run(action: action, find: find).flatMap { condition($0) == true ? $0 : nil }
        }
    }

}
