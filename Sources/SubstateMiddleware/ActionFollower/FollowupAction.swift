import Substate

/// An action which provides another followup action to be triggered immediately after it.
///
public protocol FollowupAction {
    var followup: Action { get }
}

/// An action which provides more than one followup action to be triggered immediately after it.
///
public protocol MultipleFollowupAction {
    var followup: [Action] { get }
}
