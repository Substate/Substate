extension ActionTriggerStep2 {

    public func accept(when constant: @autoclosure @escaping () -> Bool?) -> ActionTriggerStep2<Output1, Output2> {
        ActionTriggerStep2 { action, find in
            run(action: action, find: find).flatMap { constant() == true ? ($0, $1) : nil }
        }
    }

    public func accept(when condition: @escaping (Output1, Output2) -> Bool) -> ActionTriggerStep2<Output1, Output2> {
        ActionTriggerStep2 { action, find in
            run(action: action, find: find).flatMap { condition($0, $1) ? ($0, $1) : nil }
        }
    }

    public func accept(when condition: @escaping (Output1, Output2) -> Bool?) -> ActionTriggerStep2<Output1, Output2> {
        ActionTriggerStep2 { action, find in
            run(action: action, find: find).flatMap { condition($0, $1) == true ? ($0, $1) : nil }
        }
    }

}
