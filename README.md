# Structure

Structure is a Redux-style library for Swift.

IDEA: States are generic WRT the action type and the stort automatically sends actions only to substates that can handle the current action. Actions could then either be structs or enums.
```
// Stricter, handle all known cases
enum SettingsAction: Action {
    case sort(Sort)
    case filter(Filter)
}

// Looser, handle actions from other modules, easily tag types for processing in middleware
protocol SettingsAction: Action {}
struct UpdateSort: SettingsAction { let sort: Sort }
struct UpdateFilter: SettingsAction { let filter: Filter }
```

IDEA: Should reducer composition work deepest-substate-first? Then parents can make use of already-updated child state.

## Example

```swift
import Structure

struct Increment: Action {}
struct Decrement: Action {}

struct AppState {
    var counter = 0
}

extension AppState: State {
    mutating func update(action: Action) {
        switch action {
        case is Increment: counter += 1
        case is Decrement: counter -= 1
        default: ()
        }
    }
}

struct Todos: State {
    var list: [Todo] = []
}

struct Settings: State {
    var sort: Sort = .date
    var filter: Filter = .none   

    enum Sort { case date, title }
    enum Filter { case none, contains(String) }
    
    mutating func update(action: Action) {
        switch action {
        
        }
    }
}

```

## Reducer Composition

- Existing libraries require manual composition of child reducers
- Flite uses a convention where states specify their own reducer — not as pure but much more ergonomic as all the state:reducer mappings don’t need to be specified manually
- Flite then uses Swift’s type system to walk your app’s state struct, and automatically identify sub-states which it can then reduce
- You can manually specify reducers and reducer order for more control (?)
 
## Substate Selection

mention redux-selector from JS.
similar approach can work fine in Swift, narrowing app state to desired state for views.
but 










