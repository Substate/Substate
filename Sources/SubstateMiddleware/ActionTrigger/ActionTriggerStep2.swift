import Substate

@MainActor public struct ActionTriggerStep2<Output1, Output2> {

    let closure: (Action, Store) -> AsyncStream<(Output1, Output2)>

    func run(action: Action, store: Store) -> AsyncStream<(Output1, Output2)> {
        closure(action, store)
    }

}
