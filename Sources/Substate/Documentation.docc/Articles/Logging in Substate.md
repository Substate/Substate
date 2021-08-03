# Logging in Substate

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

## Overview

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

```swift
let store = Store(model: Counter(), middleware: [StateLogger(), ActionLogger()])
store.update(Counter.Reset(to: 100))
```

```swift
▿ Substate.State: Counter
  - value: 0
▿ Substate.Action: Counter.Reset
  - to: 100
▿ Substate.State: Counter
  - value: 100
```

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

```swift
struct Increment: Action {}
struct Decrement: Action, LoggedAction {}

let store = Store(model: Counter(), middleware: [ActionLogger(filter: true)]

store.update(Counter.Increment())
store.update(Counter.Decrement())
```

```swift
- Substate.Action: Counter.Decrement
```

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

```swift
struct LoggerDebugView: View {
    @Model state: ActionLogger.State
    var body: some View {
        Text("Logging Actions: \(state.isActive)")
        Button("Toggle", action: update(ActionLogger.Toggle()))
    }
}
```
