import Substate

public struct ActionTriggerStep1<Output> {

    let closure: (Action, @escaping (Model.Type) -> Model?) -> AsyncStream<Output>

    func run(action: Action, find: @escaping (Model.Type) -> Model?) -> AsyncStream<Output> {
        closure(action, find)
    }

}
