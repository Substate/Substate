import Substate

/// Helper for testing. Keeps a flat list of triggered actions.
///
public class ActionCatcher: Middleware {

    public var actions: [Action] = []

    public func find<A:Action>(_: A.Type) -> [A] {
        actions.compactMap { $0 as? A }
    }

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
