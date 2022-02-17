import Substate

public typealias ActionTrigger = (Action, (Model.Type) -> Model?) async -> Action?
