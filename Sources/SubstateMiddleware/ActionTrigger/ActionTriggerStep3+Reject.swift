extension ActionTriggerStep3 {

    public func reject(when constant: @autoclosure @escaping () -> Bool?) -> ActionTriggerStep3<Output1, Output2, Output3> {
        ActionTriggerStep3 { action, find in
            run(action: action, find: find).flatMap { constant() == true ? nil : ($0, $1, $2) }
        }
    }

    public func reject(when condition: @escaping (Output1, Output2, Output3) -> Bool) -> ActionTriggerStep3<Output1, Output2, Output3> {
        ActionTriggerStep3 { action, find in
            run(action: action, find: find).flatMap { condition($0, $1, $2) == true ? nil : ($0, $1, $2) }
        }
    }

    public func reject(when condition: @escaping (Output1, Output2, Output3) -> Bool?) -> ActionTriggerStep3<Output1, Output2, Output3> {
        ActionTriggerStep3 { action, find in
            run(action: action, find: find).flatMap { condition($0, $1, $2) == true ? nil : ($0, $1, $2) }
        }
    }

}
