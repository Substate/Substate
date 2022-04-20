import Substate

public typealias ActionTrigger = @Sendable @MainActor (Action, Store) -> AsyncStream<Action>
