import Substate

public class ActionFollower: Middleware {

    public init() {}

    public let model: Model? = nil

    public func setup(store: Store) {}

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
