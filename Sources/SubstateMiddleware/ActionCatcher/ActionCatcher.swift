import Substate

/// Helper for testing. Keeps a flat list of triggered actions.
///
public class ActionCatcher: Middleware {

    @MainActor public var actions: [Action] = []

    @MainActor public func find<A:Action>(_: A.Type) -> [A] {
        actions.compactMap { $0 as? A }
    }

    @MainActor public func count<A:Action>(for _: A.Type) -> Int {
        actions.compactMap { $0 as? A }.count
    }

    public init() {}

    public func configure(store: Store) -> (@escaping DispatchFunction) -> DispatchFunction {
        { next in
            { action in
                self.actions.append(action)
                try await next(action)
            }
        }
    }

}
