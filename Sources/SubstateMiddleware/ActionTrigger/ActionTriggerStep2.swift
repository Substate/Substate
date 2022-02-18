import Substate

public struct ActionTriggerStep2<Output1, Output2> {

    let closure: (Action, @escaping (Model.Type) -> Model?) -> AsyncStream<(Output1, Output2)>

    func run(action: Action, find: @escaping (Model.Type) -> Model?) -> AsyncStream<(Output1, Output2)> {
        closure(action, find)
    }

}
