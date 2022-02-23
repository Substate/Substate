import Substate

public struct ActionTriggerStepFinal<ActionType:Action> {

    let closure: (Action, @escaping (Model.Type) -> Model?) -> AsyncStream<ActionType>

    func run(action: Action, find: @escaping (Model.Type) -> Model?) -> AsyncStream<ActionType> {
        closure(action, find)
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
            { (action: Action, find: @escaping (Model.Type) -> Model?) -> AsyncStream<Action> in
                AsyncStream { continuation in
                    Task {
                        for await action in self.run(action: action, find: find) {
                            continuation.yield(action)
                        }

                        continuation.finish()
                    }
                }
            }
        ]

    }
}
