extension ActionTriggerStep3 {

    public func accept(when constant: @autoclosure @escaping () -> Bool?) -> ActionTriggerStep3<Output1, Output2, Output3> {
        ActionTriggerStep3 { action, find in
            run(action: action, find: find).flatMap { constant() == true ? ($0, $1, $2) : nil }
        }
    }

    public func accept(when condition: @escaping (Output1, Output2, Output3) -> Bool) -> ActionTriggerStep3<Output1, Output2, Output3> {
        ActionTriggerStep3 { action, find in
            run(action: action, find: find).flatMap { condition($0, $1, $2) ? ($0, $1, $2) : nil }
        }
    }

    public func accept(when condition: @escaping (Output1, Output2, Output3) -> Bool?) -> ActionTriggerStep3<Output1, Output2, Output3> {
        ActionTriggerStep3 { action, find in
            run(action: action, find: find).flatMap { condition($0, $1, $2) == true ? ($0, $1, $2) : nil }
        }
    }

}
