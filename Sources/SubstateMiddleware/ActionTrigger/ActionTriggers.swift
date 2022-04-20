import Foundation
import Substate

@MainActor public class ActionTriggers {

    public let triggers: [ActionTrigger]

    public init(@ActionTriggersBuilder triggers: () -> [ActionTriggerProvider]) {
        self.triggers = triggers().flatMap(\.triggers)
    }

    @resultBuilder public struct ActionTriggersBuilder {
        public static func buildBlock(_ triggers: ActionTriggerProvider...) -> [ActionTriggerProvider] {
            triggers
        }
    }

    func run(action: Action, store: Store) -> AsyncStream<Action> {
        AsyncStream { continuation in
            Task {
                await withTaskGroup(of: Void.self) { @MainActor group in
                    for trigger in triggers {
                        group.addTask { @MainActor in
                            for await result in trigger(action, store) {
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

                Task {
                    for await action in self.run(action: action, store: store) {
                        try await store.dispatch(action)
                    }
                }
            }
        }
    }
}
