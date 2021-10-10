import Substate

extension Action {

    /// Accept an action by constant.
    ///
    public static func accept(when constant: @autoclosure @escaping () -> Bool?) -> ActionTriggerStep1<Self> {
        ActionTriggerStep1 { action, find in
            (action as? Self).flatMap { constant() == true ? $0 : nil }
        }
    }

    public static func accept(when condition: @escaping (Self) -> Bool) -> ActionTriggerStep1<Self> {
        ActionTriggerStep1 { action, find in
            (action as? Self).flatMap { condition($0) == true ? $0 : nil }
        }
    }

    public static func accept(when condition: @escaping (Self) -> Bool?) -> ActionTriggerStep1<Self> {
        ActionTriggerStep1 { action, find in
            (action as? Self).flatMap { condition($0) == true ? $0 : nil }
        }
    }

}
