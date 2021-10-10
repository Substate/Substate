import Foundation
import Substate

/// TODO: Get rid of this root class and make the individual 'ActionTriggerList's conform to the
/// middleware protocol to avoid the useless layer of wrapping.
/// 
public class ActionTrigger: Middleware {

    // MARK: - Initialisation

    private let triggers: [ActionTriggerFunction]

    public init(sources: ActionTriggerList...) {
        self.triggers = sources.flatMap(\.triggers)
    }

    // MARK: - Middleware API

    public func update(send: @escaping Send, find: @escaping Find) -> (@escaping Send) -> Send {
        return { next in
            return { action in
                self.triggers.forEach { trigger in
                    trigger(action, { find($0).first }).map(send)
                }

                next(action)
            }
        }
    }

}

