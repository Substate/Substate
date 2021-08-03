import Foundation
import Substate
import SubstateMiddleware

struct Tasks: Model, SavedModel {

    var all: [Task] = []

    struct Create: Action, FollowupAction {
        let body: String

        let followup: Action = Changed()
    }

    struct Update: Action, FollowupAction {
        let id: UUID
        let body: String

        let followup: Action = Changed()
    }

    struct Delete: Action, FollowupAction {
        let id: UUID

        let followup: Action = Changed()
    }

    struct Toggle: Action, FollowupAction {
        let id: UUID

        let followup: Action = Changed()
    }

    struct Changed: Action {}

    mutating func update(action: Action) {
        switch action {

        case let action as Create:
            all.append(Task(id: UUID(), date: Date(), body: action.body))

        case let action as Update:
            all.firstIndex(where: { $0.id == action.id }).map { index in
                all[index].body = action.body
            }

        case let action as Delete:
            all.removeAll { $0.id == action.id }

        case let action as Toggle:
            all.firstIndex(where: { $0.id == action.id }).map { index in
                all[index].completed.toggle()
            }

        default: ()
        }
    }

}

extension Tasks {
    static let sample = Tasks(all: [
        .init(id: .init(), date: .init(), body: "Lorem ipsum dolor sit amet."),
        .init(id: .init(), date: .distantFuture, body: "Consectetur adipiscing elit sed."),
        .init(id: .init(), date: .distantPast, body: "Do eismod tempor elit.")
    ])
}
