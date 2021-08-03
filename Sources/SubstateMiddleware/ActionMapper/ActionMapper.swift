import Foundation
import Substate

/// Deprecated
public class ActionMapper: Middleware {

    // MARK: - Initialisation

    private let items: [ActionMapItem]

    public init(maps: ActionMap...) {
        self.items = maps.flatMap(\.items)
    }

    // MARK: - Middleware API

    public var model: Model?

    public func setup(store: Store) {}

    public func update(store: Store) -> (@escaping Update) -> Update {
        return { next in
            return { action in
                self.items.forEach { item in
                    if let newAction = item(action, store.uncheckedFind) {
                        store.update(newAction)
                    }
                }

                next(action)
            }
        }
    }

}
