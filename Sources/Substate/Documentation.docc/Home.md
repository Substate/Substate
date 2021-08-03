# ``Substate``

A tiny state management library for Swift.

[![Banner](SubstateBanner)](https://substate.dev)

Substate is a Redux-style state management library consisting of actions, models, and a store. The goal is to leverage Swift’s type system to provide the most ergonomic possible version of the pattern.

[![Banner](SubstateUIBanner)](https://substate.dev/documentation/substateui)

Access your Substate models from SwiftUI views, and dispatch actions to update them. Bootstrap your app from SwiftUI, and inject models into previews.

[![Banner](SubstateMiddlewareBanner)](https://substate.dev/documentation/substatemiddleware)

Extend Substate with logging, async tasks, time control, persistent models, action mapping logic, and a standalone debugging app. Connect your own services to Substate.

## 🎚 Models

```swift
import Substate
```

Describe your model using a simple value type. Add some `Action`s that will trigger model updates.

```swift
struct Counter: Model {
    var value = 0

    struct Increment: Action {}
    struct Decrement: Action {}

    mutating func update(action: Action) {
        switch action {
        case is Increment: value += 1
        case is Decrement: value -= 1
        default: ()
        }
    }
}
```

Then, conform to `Model` by adding an `update(action:)` method and define how the model should change when actions are received.

- ``Model``
- <doc:Create-a-Model>
- <doc:Advanced-Model-Composition>

## 🎛 Nesting

Add other models alongside plain values to compose a state tree for your program.

```swift
struct Counter: Model {
    var value = 0
    var subCounter = SubCounter()

    mutating func update(action: Action) { ... }
}
```

Nested models are automatically detected and updated using their own `update(action:)` methods.

```swift
struct SubCounter: Model {
    var value = 0

    mutating func update(action: Action) { ... }
}
```

- ``Model``
- <doc:Creating-Reusable-Models>
- <doc:Automatic-Model-Detection>

## ⭐️ Views

```swift
import SubstateUI
```

Add `@Model` properties to access models from your views.

```swift
struct CounterView: View {
    @Model var counter: Counter
    @Model var subCounter: SubCounter

    var body: some View {
        Text("Count: \(counter.value)")
        Text("Subcount: \(subCounter.value)")
    }
}
```

Use an `@Update` property to trigger model updates.

```swift
struct CounterView: View {
    @Update var update

    var body: some View {
        Button("Increment", action: update(Counter.Increment()))
        Button("Decrement", action: update(Counter.Decrement()))
    }
}
```

Learn more about views:

- [`@Model`](https://substate.dev/documentation/substateui/model)
- [`@Update`](https://substate.dev/documentation/substateui/update)

## 🌟 Previews

Extend your model with data for use in different previews.

```swift
extension Counter {
    static let zero = Counter(value: 0)
    static let random = Counter(value: .random(in: 1...100))
}
```

Pass your predefined models in to the `model(_:)` view modifier.

```swift
struct CounterViewPreviews: PreviewProvider {
    static var previews: some View {
        CounterView().model(Counter.zero)
        CounterView().model(Counter.random)
    }
}
```

- [`View.model(_:)`](https://substate.dev/documentation/substateui)

## 🗄 Stores

Bootstrap your program by passing in a root model and a list of middleware to the `store(_:)` view modifier.

```swift
struct CounterApp: App {
    var scene: some Scene {
        CounterView().store(model: Counter(), middleware: [])
    }
}
```

For more control or to use Substate separately from SwiftUI, create a store manually.

```swift
let store = Store(model: Counter(), middleware: [])
```

Retrieve models directly from the store by passing a model type to `find(_:)`.

```swift
store.find(Counter.self) // => Optional<Counter>
store.find(SubCounter.self) // => Optional<SubCounter>
```

Update your app’s model directly by passing an action to `update(_:)`.

```swift
store.update(Counter.Increment())
```

- ``Store``
- [`View.store(_:)`](https://substate.dev/documentation/substateui)

## 🛠 Middleware

```swift
import SubstateMiddleware
```

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

### Logging

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

- [`ModelLogger`](https://substate.dev/documentation/substatemiddleware/modellogger)
- [`ActionLogger`](https://substate.dev/documentation/substatemiddleware/actionlogger)
- <doc:Logging-in-Substate>

### Timing

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

```swift
struct DismissModal: DelayedAction {
    let id: UUID
    let delay: TimeInterval = 5
}
```

- [`ActionDelayer`](https://substate.dev/documentation/substatemiddleware/actiondelayer)
- [`ActionTimer`](https://substate.dev/documentation/substatemiddleware/actiontimer)

### Persistence

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

```swift
struct TaskList: Model, SavedModel { ... }
```

```swift
▿ Substate.Action: SubstateMiddleware.ModelSaver.LoadDidSucceed
  - model: Todos.TaskList
▿ Substate.Action: Substate.Store.Replace
  - model: Todos.TaskList
▿ Substate.Action: SubstateMiddleware.ModelSaver.UpdateDidComplete
  - type: Todos.TaskList
```

```swift
- Substate.Action: Counter.Counter.Increment
- Substate.Action: SubstateMiddleware.ModelSaver.SaveAll
▿ Substate.Action: SubstateMiddleware.ModelSaver.SaveDidSucceed
  - type: Todos.TaskList
```

- [`ModelSaver`](https://substate.dev/documentation/substatemiddleware/modelsaver)

### App Logic

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

```swift
let appActionMap = ActionMap {
    TaskList.Create
        .map(to: Sounds.Play(.blip))

    TaskList.Delete
        .map(to: Sounds.Play(.crunch))

    TaskList.Create
        .map(to: Notifications.Show(message: "Task Created"))

    TaskList.Delete
        .map(to: Notifications.Show(message: "Task Deleted"))

    TaskList.Changed
        .map(\TaskList.all.count, to: Titlebar.UpdateCount.init)

    ModelSaver.UpdateDidComplete
        .map(\TaskList.all.count, to: Titlebar.UpdateCount.init)
}
```

- [`ActionMapper`](https://substate.dev/documentation/substatemiddleware/actionmapper)

### Debugging

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

![Mac App Screenshot](MacAppScreenshot)

### Custom Middleware

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

## 📦 Packaging

- List benefits of automatic sub-state selection for separating components into packages
- Views don’t need to know about any parent types from the tree so they can be in their own packages if desired
- Can make some of a component’s actions public and some private to the package
- Can create full component view previews with just the state in a package and no external top-down setup

## ✅ Testing

Test models by creating a store and sending actions to it. Use the store’s `find(_:)` method to query values.

```swift
func testCounter() throws {
    let store = Store(model: Counter())
    XCTAssertEqual(store.find(Counter.self)?.value, 0)

    store.update(Counter.Increment())
    XCTAssertEqual(store.find(Counter.self)?.value, 1)

    store.update(SubCounter.Increment())
    XCTAssertEqual(store.find(SubCounter.self)?.value, 1)
}
```

Pass in alternate services to provide behaviour appropriate for your tests. Anything goes — no need to subclass or otherwise hijack your production services unless you want to.

```swift
class FixedNumberFetcher: Service {
    func handle(action: Action) -> AnyPublisher<Action, Never> {
        Just(Numbers.FetchDidSucceed(number: 10)).eraseToAnyPublisher()
    }
}

class FailingNumberFetcher: Service {
    enum NumberFetcherError { case test }
    func handle(action: Action) -> AnyPublisher<Action, Never> {
        Just(Numbers.FetchDidFail(error: NumberFetcherError.test)).eraseToAnyPublisher()
    }
}

let store1 = Store(model: Counter(), middleware: [FixedNumberFetcher()])
let store2 = Store(model: Counter(), middleware: [FailingNumberFetcher()])
```

## 💣 Escaping

- List escape hatches for code that uses global state
- Pretty straightforward, just keep a global reference to the store and dispatch anywhere
- Use one of the middleware to subscribe to changes, make it a singleton if you want
- Get and set state manually when needed
- Subscribe via callback to the store

## Swift Concurrency Support

TODO.

```swift
protocol Service {
    func handle(action: Action) async -> Action // Or AsyncSequence?
}
```

## 🙏 Acknowledgements

Substate’s novelty is in using Swift’s type system to automatically select child states. The rest is inspired by and lifted from a variety of other wonderful projects. In no particular order:

- [Elm](https://elm-lang.org)
- [Redux](https://redux.js.org)
- [TCA](https://www.pointfree.co/collections/composable-architecture)

- [SwiftUIFlux](https://github.com/Dimillian/SwiftUIFlux)
- [ReSwift](https://github.com/ReSwift/ReSwift)
- [Fluxor](https://fluxor.dev)

## Topics

### Essentials

- <doc:Quick-Start>
- ``Store``
- ``Action``
- ``Model``
- ``Middleware``
