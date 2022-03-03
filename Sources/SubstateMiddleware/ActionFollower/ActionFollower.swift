import Substate

/// Middleware allowing an action to specify one or more other actions that should fire right after it.
/// 
public class ActionFollower: Middleware {

    public init() {}

    public func configure(store: Store) -> (@escaping DispatchFunction) -> DispatchFunction {
        { next in
            { action in
                try await next(action)

                if let action = action as? FollowupAction {
                    try await store.dispatch(action.followup)
                }

                if let action = action as? MultipleFollowupAction {
                    for action in action.followup {
                        try await store.dispatch(action)
                    }
                }
            }
        }
    }

}
