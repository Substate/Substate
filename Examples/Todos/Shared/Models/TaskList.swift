import Foundation
import Substate

struct TaskList: Model {

    var filter = Todos.Filter()

    var all: [Task] = [.sample1, .sample2, .sample3]

    var filteredTasks: [Task] {
        all.filter {
            switch filter.category {
            case .all: return true
            case .upcoming: return !$0.completed
            case .completed: return $0.completed
            case .deleted: return false
            }
        }
    }

    var filteredTaskCount: Int {
        filteredTasks.count
    }

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

    struct Toggle: Action {
        let id: UUID
    }

    // Just for testing, but could move more to something like this, where the tasklist keeps its
    // own filter state as a plain value and reacts a filter action that is passed in, triggered
    // from some view somewhere and passing through a 'transformer'
    struct Filter: Action {
        let filter: Todos.Filter
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

        case let action as Toggle:
            all.firstIndex(where: { $0.id == action.id }).map { index in
                all[index].completed.toggle()
            }

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
