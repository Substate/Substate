import Substate

public struct ActionTriggerStep1<Output> {

    let closure: (Action, (Model.Type) -> Model?) async -> Output?

    func run(action: Action, find: (Model.Type) -> Model?) async -> Output? {
        await closure(action, find)
    }

}
