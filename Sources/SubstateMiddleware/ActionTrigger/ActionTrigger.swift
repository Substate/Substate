import Substate

public typealias ActionTrigger = (Action, @escaping (Model.Type) -> Model?) -> AsyncStream<Action>
