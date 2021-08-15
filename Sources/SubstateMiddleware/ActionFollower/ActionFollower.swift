import Substate

/// Middleware allowing an action to specify one or more other actions that should fire right after it.
/// 
public class ActionFollower: Middleware {

    public init() {}

    public func update(store: Store) -> (@escaping Update) -> Update {
        return { next in
            return { action in
                next(action)

                if let action = action as? FollowupAction {
                    store.update(action.followup)
                }

                if let action = action as? MultipleFollowupAction {
                    action.followup.forEach(store.update)
                }
            }
        }
    }

}
