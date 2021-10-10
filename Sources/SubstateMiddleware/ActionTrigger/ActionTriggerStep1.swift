import Substate

public struct ActionTriggerStep1<Output> {

    let closure: (Action, (Model.Type) -> Model?) -> Output?

    func run(action: Action, find: (Model.Type) -> Model?) -> Output? {
        closure(action, find)
    }

}
