import Substate

public struct ActionTriggerStep3<Output1, Output2, Output3> {

    let closure: (Action, (Model.Type) -> Model?) async -> (Output1, Output2, Output3)?

    func run(action: Action, find: (Model.Type) -> Model?) async -> (Output1, Output2, Output3)? {
        await closure(action, find)
    }

}
