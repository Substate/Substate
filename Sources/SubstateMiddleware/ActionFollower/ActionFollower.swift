import Substate

/// Middleware allowing an action to specify one or more other actions that should fire right after it.
/// 
public class ActionFollower: Middleware {

    public init() {}

    public func update(send: @escaping Send, find: @escaping Find) -> (@escaping Send) -> Send {
        return { next in
            return { action in
                next(action)

                if let action = action as? FollowupAction {
                    send(action.followup)
                }

                if let action = action as? MultipleFollowupAction {
                    action.followup.forEach(send)
                }
            }
        }
    }

}
