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

    func run(action: Action, find: @escaping (Model.Type) -> Model?) -> AsyncStream<Action> {
        AsyncStream { continuation in
            Task.detached {
                await withTaskGroup(of: Void.self) { group in
                    for trigger in triggers {
                        group.addTask {
                            for await result in trigger(action, find) {
                                if result is VoidAction { continue }
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
    public func configure(store: Store) -> (@escaping DispatchFunction) -> DispatchFunction {
        { next in
            { action in
                try await next(action)

                for await action in run(action: action, find: { store.find($0).first }) {
                    try await store.dispatch(action)
                }
            }
        }
    }
}
