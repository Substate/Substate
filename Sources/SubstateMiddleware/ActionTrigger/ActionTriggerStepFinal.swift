import Substate

public struct ActionTriggerStepFinal<ActionType:Action> {

    let closure: (Action, (Model.Type) -> Model?) async -> ActionType?

    func run(action: Action, find: (Model.Type) -> Model?) async -> ActionType? {
        await closure(action, find)
    }

}

extension ActionTriggerStepFinal {

    @available(*, unavailable, message: "Trigger can’t be called more that once in a pipeline")
    public func trigger() -> ActionTriggerStepFinal {
        fatalError()
    }

}

extension ActionTriggerStepFinal: ActionTriggerProvider {
    public var triggers: [ActionTrigger] { [closure] }
}
