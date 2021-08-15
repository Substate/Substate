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
        let followup: Action = Changed()
    }

    struct Dismiss: Action, FollowupAction {
        let id: UUID
        let followup: Action = Changed()
    }

    struct Changed: Action {}

    struct DismissAfterDelay: Action, DelayedAction {
        let delay: TimeInterval = 2
    }

    mutating func update(action: Action) {
        switch action {

        case let action as Show:
            notifications.append(.init(id: action.id, message: action.message))

        case let action as Dismiss:
            notifications.removeAll { $0.id == action.id }

        case is DismissAfterDelay:
            if !notifications.isEmpty {
                notifications.removeLast()
            }

        default:
            ()
        }
    }

}

extension String {
    static let taskCreated = "Task Created"
    static let taskDeleted = "Task Deleted"
}

extension Notifications.Notification {
    static let preview = Notifications.Notification(id: .init(), message: "This is a notification")
}

extension Notifications {
    static let preview = Notifications(notifications: [
        .preview, .preview, .preview
    ])
}
