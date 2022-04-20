import Substate

@MainActor public struct ActionTriggerStep1<Output> {

    let closure: (Action, Store) -> AsyncStream<Output>

    func run(action: Action, store: Store) -> AsyncStream<Output> {
        closure(action, store)
    }

}
