extension ActionTriggerStep1 {

    public func reject(when constant: @autoclosure @escaping () -> Bool?) -> ActionTriggerStep1<Output> {
        ActionTriggerStep1 { action, find in
            run(action: action, find: find).flatMap { constant() == true ? nil : $0 }
        }
    }

    public func reject(when condition: @escaping (Output) -> Bool) -> ActionTriggerStep1<Output> {
        ActionTriggerStep1 { action, find in
            run(action: action, find: find).flatMap { condition($0) == true ? nil : $0 }
        }
    }

    public func reject(when condition: @escaping (Output) -> Bool?) -> ActionTriggerStep1<Output> {
        ActionTriggerStep1 { action, find in
            run(action: action, find: find).flatMap { condition($0) == true ? nil : $0 }
        }
    }

}
