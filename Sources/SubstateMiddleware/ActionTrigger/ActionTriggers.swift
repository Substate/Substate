import Foundation
import Substate

public struct ActionTriggers {

    public let triggers: [ActionTrigger]

    public init(triggers: [ActionTriggerProvider]) {
        self.triggers = triggers.flatMap(\.triggers)
    }

    #if compiler(>=5.4)

    public init(@ActionTriggersBuilder triggers: () -> [ActionTriggerProvider]) {
        self.triggers = triggers().flatMap(\.triggers)
    }

    @resultBuilder public struct ActionTriggersBuilder {
        public static func buildBlock(_ triggers: ActionTriggerProvider...) -> [ActionTriggerProvider] {
            triggers
        }
    }

    #endif

    func run(action: Action, find: (Model.Type) -> Model?) async -> [Action] {
        var actions: [Action] = []

        for trigger in triggers {
            if let output = await trigger(action, find) {
                actions.append(output)
            }
        }

        return actions
    }

}

extension ActionTriggers: ActionTriggerProvider {}

extension ActionTriggers: Middleware {
    public func update(send: @escaping Send, find: @escaping Find) -> (@escaping Send) -> Send {
        return { next in
            return { action in
                self.triggers.forEach { trigger in
                    // We use DispatchQueue.main here as a stopgap while the rest of the codebase is
                    // refactored for Swift Concurrency. Otherwise, the trigger will not be on main.
                    DispatchQueue.main.async {
                        Task { await trigger(action, { find($0).first }).map(send) }
                    }
                }

                next(action)
            }
        }
    }
}

