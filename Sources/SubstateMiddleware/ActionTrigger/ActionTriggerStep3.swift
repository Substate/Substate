import Substate

public struct ActionTriggerStep3<Output1, Output2, Output3> {

    let closure: (Action, (Model.Type) -> Model?) -> (Output1, Output2, Output3)?

    func run(action: Action, find: (Model.Type) -> Model?) -> (Output1, Output2, Output3)? {
        closure(action, find)
    }

}
