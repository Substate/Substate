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

    // TODO: Add a version of run here which is async -> [Action] for use in testing, where we
    // don’t really want to subscribe to a stream we just want to await the whole list of actions.

    func run(action: Action, find: @escaping (Model.Type) -> Model?) -> AsyncStream<Action> {
        AsyncStream { continuation in
            Task {
                await withTaskGroup(of: Void.self) { group in
                    for trigger in triggers {
                        group.addTask {
                            for await result in trigger(action, find) {
                                continuation.yield(result)
                            }
                        }
                    }

                    await group.waitForAll()
                    continuation.finish()
                }
            }
        }
    }

}

extension ActionTriggers: ActionTriggerProvider {}

extension ActionTriggers: Middleware {
    public func update(send: @escaping Send, find: @escaping Find) -> (@escaping Send) -> Send {
        return { next in
            return { action in
                next(action)

                Task { @MainActor in
                    for await output in run(action: action, find: { find($0).first }) {
                        send(output)
                    }
                }
            }
        }
    }
}
