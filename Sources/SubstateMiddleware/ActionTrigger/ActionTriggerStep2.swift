import Substate

public struct ActionTriggerStep2<Output1, Output2> {

    let closure: (Action, (Model.Type) -> Model?) -> (Output1, Output2)?

    func run(action: Action, find: (Model.Type) -> Model?) -> (Output1, Output2)? {
        closure(action, find)
    }

}
