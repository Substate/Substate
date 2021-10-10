import Substate

extension Action {

    public static func reject(when constant: @autoclosure @escaping () -> Bool?) -> ActionTriggerStep1<Self> {
        ActionTriggerStep1 { action, find in
            (action as? Self).flatMap { constant() == true ? nil : $0 }
        }
    }

    public static func reject(when condition: @escaping (Self) -> Bool) -> ActionTriggerStep1<Self> {
        ActionTriggerStep1 { action, find in
            (action as? Self).flatMap { condition($0) == true ? nil : $0 }
        }
    }

    public static func reject(when condition: @escaping (Self) -> Bool?) -> ActionTriggerStep1<Self> {
        ActionTriggerStep1 { action, find in
            (action as? Self).flatMap { condition($0) == true ? nil : $0 }
        }
    }

}
