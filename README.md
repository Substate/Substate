# Substate

Substate is a state management library for Swift.

## Example

Create an overall model representing the app’s state and actions, containing sub-states.

```swift
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
```

Define sub-states with their own actions and update routines.

```swift
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
```

Set up the root view.

```swift
import SwiftUI
import Substate

@main struct TodosApp: App {
    let store = Store(state: Root())

    var body: some Scene {
        WindowGroup {
            AppView().environmentObject(store)
        }
    }
}
```

## Views

```swift
struct TodosView: View {
    var body: some View {
        Container(for: Todos.self) { state, dispatch in
            ForEach(state.list) { todo in
                // ...
            }
        }
    }
}
```

## Previews

Pass in only the required sub-states to a store attached to the preview view — no need to pass in the full root state (especially useful if your sub-state/view is in a Swift package). Extend your states with mock data and pass that in for convenience.

```swift
extension Todos {
    static let full = Todos(/* ... */)
    static let empty = Todos(/* ... */)
}

struct TodosViewPreview: PreviewProvider {
    static var previews: some View {
        Group {
            TodosView().environmentObject(Store(state: Todos.full))
            TodosView().environmentObject(Store(state: Todos.empty))
        }
    }
}
```