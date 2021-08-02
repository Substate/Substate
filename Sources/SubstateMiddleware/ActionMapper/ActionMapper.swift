import Foundation
import Substate

public class ActionMapper: Middleware {

    // MARK: - Initialisation

    let items: [ActionMapItem]

    public init(map: ActionMap) {
        self.items = map.items
    }

    public init(maps: ActionMap...) {
        self.items = maps.flatMap(\.items)
    }

    // MARK: - Middleware API

    public var model: Model?

    public func setup(store: Store) {}

    public func update(store: Store) -> (@escaping Update) -> Update {
        return { next in
            return { action in
                next(action)
                self.items.forEach { item in
                    if let newAction = item(action, store.uncheckedFind) {
                        store.update(newAction)
                    }
                }
            }
        }
    }

}
