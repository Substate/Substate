import Substate

public protocol FollowupAction {
    var followup: Action { get }
}

public protocol MultipleFollowupAction {
    var followup: [Action] { get }
}
