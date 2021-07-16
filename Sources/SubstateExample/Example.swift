import Foundation
import Substate

struct App: State {
    var isActive = false

    var todos = Todos() // Auto-detected as a sub-state
    var settings = Settings() // Auto-detected as a sub-state

    struct AppDidEnterForeground: Action {}
    struct AppDidEnterBackground: Action {}

    mutating func update(action: Action) {
        switch action {

        case is AppDidEnterForeground:
            isActive = true

        case is AppDidEnterBackground:
            isActive = false

        default: ()
        }
    }
}

struct Todos: State {
    var list: [Todo] = []

    struct CreateTodo: Action {
        let body: String
    }

    struct DestroyTodo: Action {
        let index: Int
    }

    mutating func update(action: Action) {
        switch action {

        case let action as CreateTodo:
            list.append(Todo(date: Date(), body: action.body))

        case let action as DestroyTodo:
            list.remove(at: action.index)

        default: ()
        }
    }
}

struct Settings: State {
    var title = "My To-Do List"

    struct ChangeTitle: Action {
        let title: String
    }

    mutating func update(action: Action) {
        if let action = action as? ChangeTitle {
            title = action.title
        }
    }
}

//

struct Todo: Identifiable {
    let date: Date
    let body: String

    var id: Date { date }
}

