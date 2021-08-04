import Foundation
import Substate

public class ActionTrigger: Middleware {

    // MARK: - Initialisation

    private let triggers: [ActionTriggerFunction]

    public init(sources: ActionTriggerList...) {
        self.triggers = sources.flatMap(\.triggers)
    }

    // MARK: - Middleware API

    public var model: Model?

    public func setup(store: Store) {}

    public func update(store: Store) -> (@escaping Update) -> Update {
        return { next in
            return { action in
                self.triggers.forEach { trigger in
                    trigger(action, store.uncheckedFind).map(store.update)
                }

                next(action)
            }
        }
    }

}
