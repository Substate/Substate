import Substate

/// Helper for testing. Keeps a flat list of triggered actions.
///
public class ActionCatcher: Middleware {

    public var actions: [Action] = []

    public init() {}

    public func update(send: @escaping Send, find: @escaping Find) -> (@escaping Send) -> Send {
        return { next in
            return { action in
                self.actions.append(action)
                next(action)
            }
        }
    }

}