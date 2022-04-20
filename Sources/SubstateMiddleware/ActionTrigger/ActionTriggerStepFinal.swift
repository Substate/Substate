import Substate

@MainActor public struct ActionTriggerStepFinal<ActionType:Action> {

    let closure: @MainActor (Action, Store) -> AsyncStream<ActionType>

    func run(action: Action, store: Store) -> AsyncStream<ActionType> {
        closure(action, store)
    }

}

extension ActionTriggerStepFinal {

    @available(*, unavailable, message: "Trigger can’t be called more that once in a pipeline")
    public func trigger() -> ActionTriggerStepFinal {
        fatalError()
    }

}

extension ActionTriggerStepFinal: ActionTriggerProvider {

    public var triggers: [ActionTrigger] {
        [
            // TODO: Jumping through hoops here to get from generic `-> AsyncStream<ActionType>`
            // to `-> AsyncStream<Action>` (ie. `ActionTrigger`). No doubt there’s a simpler way!
            { (action: Action, store: Store) -> AsyncStream<Action> in
                AsyncStream { continuation in
                    Task {
                        for await action in self.run(action: action, store: store) {
                            continuation.yield(action)
                        }

                        continuation.finish()
                    }
                }
            }
        ]

    }
}
