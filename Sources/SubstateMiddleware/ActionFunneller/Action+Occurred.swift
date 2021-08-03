import Substate

/// TODO: With the below and ActionMapper, we’re working towards some kind of query interface/wrapper
/// API around actions. Would be cool to formalise that and not have every middleware that is inited
/// with some kind of builder have to roll its own extensions on Action.
///
extension Action {

    public static func occurred() -> ActionFunnelStep {
        { action in action is Self }
    }

    public static func occurred(where condition: @escaping (Self) -> Bool) -> ActionFunnelStep {
        { action in
            if let action = action as? Self {
                return condition(action)
            } else {
                return false
            }

        }
    }

}
