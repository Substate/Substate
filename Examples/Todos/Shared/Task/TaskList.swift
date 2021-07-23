import Foundation
import Substate

struct TaskList: State {

    var all: [Task] = []

    struct Create: Action {
        let body: String
    }

    struct Update: Action {
        let id: UUID
        let body: String
    }

    struct Delete: Action {
        let id: UUID
    }

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

        default: ()
        }
    }

}

extension TaskList {
    static let sample = TaskList(all: [
        .init(id: .init(), date: .init(), body: "Lorem ipsum dolor sit amet."),
        .init(id: .init(), date: .distantFuture, body: "Consectetur adipiscing elit sed."),
        .init(id: .init(), date: .distantPast, body: "Do eismod tempor elit.")
    ])
}
