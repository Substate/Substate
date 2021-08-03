import Foundation
import Substate
import SubstateMiddleware

struct Notifications: Model {

    var notifications: [Notification] = []

    struct Notification: Identifiable {
        let id: UUID
        let message: String
    }

    struct Show: Action, FollowupAction {
        let id = UUID()
        let message: String

        var followup: Action { DismissAfterDelay(id: id) }
    }

    struct Dismiss: Action {
        let id: UUID
    }

    struct DismissAfterDelay: Action, DelayedAction {
        let id: UUID

        let delay: TimeInterval = 5
    }

    mutating func update(action: Action) {
        switch action {

        case let action as Show:
            notifications.append(.init(id: action.id, message: action.message))

        case let action as Dismiss:
            notifications.removeAll { $0.id == action.id }

        case let action as DismissAfterDelay:
            notifications.removeAll { $0.id == action.id }

        default:
            ()
        }
    }

}

extension String {
    static let taskCreated = "Task Created"
    static let taskDeleted = "Task Deleted"
}
