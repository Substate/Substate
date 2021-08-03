import Foundation
import Substate

public class ActionTrigger: Middleware {

    // MARK: - Initialisation

    private let results: [ActionTriggerResult]

    public init(sources: ActionTriggerList...) {
        self.results = sources.flatMap(\.results)
    }

    // MARK: - Middleware API

    public var model: Model?

    public func setup(store: Store) {}

    public func update(store: Store) -> (@escaping Update) -> Update {
        return { next in
            return { action in
                self.results.forEach { result in
                    result(action, store.uncheckedFind).map(store.update)
                }

                next(action)
            }
        }
    }

}
