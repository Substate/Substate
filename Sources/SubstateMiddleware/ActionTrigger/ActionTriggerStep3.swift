import Substate

public struct ActionTriggerStep3<Output1, Output2, Output3> {

    let closure: (Action, @escaping (Model.Type) -> Model?) -> AsyncStream<(Output1, Output2, Output3)>

    func run(action: Action, find: @escaping (Model.Type) -> Model?) -> AsyncStream<(Output1, Output2, Output3)> {
        closure(action, find)
    }

}
