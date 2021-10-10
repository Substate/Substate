extension ActionTriggerStep2 {

    public func reject(when constant: @autoclosure @escaping () -> Bool?) -> ActionTriggerStep2<Output1, Output2> {
        ActionTriggerStep2 { action, find in
            run(action: action, find: find).flatMap { constant() == true ? nil : ($0, $1) }
        }
    }

    public func reject(when condition: @escaping (Output1, Output2) -> Bool) -> ActionTriggerStep2<Output1, Output2> {
        ActionTriggerStep2 { action, find in
            run(action: action, find: find).flatMap { condition($0, $1) == true ? nil : ($0, $1) }
        }
    }

    public func reject(when condition: @escaping (Output1, Output2) -> Bool?) -> ActionTriggerStep2<Output1, Output2> {
        ActionTriggerStep2 { action, find in
            run(action: action, find: find).flatMap { condition($0, $1) == true ? nil : ($0, $1) }
        }
    }

}
