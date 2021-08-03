import Substate

/// The final type-erased function stored to compute each trigger’s result.
///
public typealias ActionTriggerResult = (Action, (Model.Type) -> Model?) -> Action?
