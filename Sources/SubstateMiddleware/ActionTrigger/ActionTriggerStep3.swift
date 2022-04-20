import Substate

@MainActor public struct ActionTriggerStep3<Output1, Output2, Output3> {

    let closure: (Action, Store) -> AsyncStream<(Output1, Output2, Output3)>

    func run(action: Action, store: Store) -> AsyncStream<(Output1, Output2, Output3)> {
        closure(action, store)
    }

}
