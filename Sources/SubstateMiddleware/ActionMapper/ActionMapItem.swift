import Substate

/// A function use to map actions over themselves and models and produce another action.
///
public typealias ActionMapItem = (Action, (Model.Type) -> Model?) -> Action?
