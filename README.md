![Substate Icon](https://www.datocms-assets.com/15979/1627080044-substate-icon.svg)

# Substate

[![Build Status](https://github.com/substate/substate/actions/workflows/swift.yml/badge.svg)](https://github.com/Substate/Substate/actions)

Substate is a state management library for Swift.

## 🎚 Models

```swift
import Substate
```

Let’s create a self-contained component. Describe your model using a simple value type.

```swift
struct Counter {
    var value = 0
}
```

Next, add some `Action`s that will trigger model updates. It’s best to define these within your model type.

```swift
extension Counter {
    struct Increment: Action {}
    struct Decrement: Action {}
}
```

Finally, conform to `Model` by adding an `update(action:)` method. Define how the value should change when actions are received.

```swift
extension Counter: State {
    mutating func update(action: Action) {
        switch action {
        case is Increment: value += 1
        case is Decrement: value -= 1
        default: ()
        }
    }
}
```

## 🎛 Nesting

Add other models alongside plain values to compose a state tree for your program.

```swift
struct Counter: State {
    var value = 0
    var subCounter = SubCounter()
    mutating func update(action: Action) { ... }
}
```

Nested models are automatically detected and updated using their own `update(action:)` methods.

```swift
struct SubCounter: State {
    var value = 0
    mutating func update(action: Action) { ... }
}
```

Reuse models in different places by making them generic with respect to their containers.

```swift
struct Tracker<Screen>: State { 
    var clicks = 0
}

struct NewsScreen: State {
    var tracker = Tracker<NewsScreen>()
}

struct ProductsScreen: State {
    var tracker = Tracker<ProductsScreen>()
}
```

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
        Button("Increment", action: update(SubCounter.Increment()))
        Button("Decrement", action: update(SubCounter.Decrement()))
    }
}
```

## 🌟 Previews

Extend your model with data for use in different previews.

```swift
extension Counter {
    static let zero = Counter(value: 0)
    static let random = Counter(value: .random(in: 1...100))
}
```

Pass your predefined models in to the `model` view modifier.

```swift
struct CounterViewPreviews: PreviewProvider {
    static var previews: some View {
        CounterView().model(Counter.zero)
        CounterView().model(Counter.random)
    }
}
```

> The `model` view modifier is an optional shorthand for `environmentObject(Store(model:))`.

## 🗄 Stores

Bootstrap your program by passing in your root state and a list of middleware to the `store` view modifier.

```swift
struct CounterApp: App {
    var scene: some Scene {
        CounterView().store(model: Counter(), middleware: [])
    }
}
```

> The `store` view modifier is an optional shorthand for `enviromentObject(Store(model:middleware:))`.

For more control, create a store separately and retain it elsewhere.

```swift
let store = Store(model: Counter(), middleware: [])
```

Retrieve models directly from the store by passing the desired type to `find`.

```swift
store.find(Counter.self) // => Optional<Counter>
store.find(SubCounter.self) // => Optional<SubCounter>
```

Update your app’s model directly by passing an action to `update`.

```swift
store.update(Counter.Increment())
```

## 👷 Middleware

```swift
import SubstateMiddleware
```

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

### 📝 Logging

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

```swift
let store = Store(model: Counter(), middleware: [StateLogger(), ActionLogger()])
store.update(Counter.Reset(to: 100))
```

```
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

```
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

### ⏱ Timing

- ActionDelayer
- ActionDebouncer
- ActionTimer

### 🪄 Effects

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

```swift
// Better name?
EffectHandler(effects: [
    .init(for: Counter.Reset.self, capture: true, counterService.fetch),
    .init(for: Counter.Reset.self, capture: true) { reset in
        counterService
            .fetch(number: reset.toValue)
            .retry(3)
            .map(CounterService.FetchDidComplete.init)
    }
    .init(state: Counter.self, action: Counter.Increment.self) { counter, increment in
        Counter.Reset(toValue: counter.value + 2) // Increment by 2 instead
    }
    .init(state: Counter.self, action: Counter.Increment.self, capture true) { counter, increment in
        print(counter.value) // Just print, return void and swallow action
    }
])

// Easily adapt any service type object for use with the effect handler
protocol EffectProvider {
    var effects: [Effect] { get } // Provide a list of effects
}

class NumberFetcher {
    func fetch(number: Int) -> AnyPublisher<Int, Error>
}

struct Effect<StateType:State> {
    // How are we going to get something that can be thrown in an array but can return different things from its handler?
    // Custom return type? Was that what they had in Fluxor?
    init(for action: Action, capturing state: StateType, passthrough: Bool = true, handler: (StateType?, Action) -> Void) {}
    init(for action: Action, capturing state: StateType, passthrough: Bool = true, handler: (StateType?, Action) -> AnyPublisher<where to get the success type?, where to get the error type?>) {}
}

// A bit verbose still? But pretty good.
extension NumberFetcher: EffectProvider {
    struct RequestDidComplete: Action {
        let value: Int
    }

    let effects: [Effect] = [
        .init(state: Counter.self, action: Counter.Increment.self, capture: true) { counter, increment in
            fetch(number: counter.value)
                .map(RequestDidComplete.init(value:))
        }
    ]
}
```

---

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

```swift

ModelPublisher() // PublishedModel
ActionPublisher() // PublishedAction

ModelLogger() // LoggedModel
ActionLogger() // LoggedAction

ModelRecorder() // RecordedModel
ActionRecorder() // RecordedAction

ActionDelayer() // DelayedAction
ActionDebouncer() // DebouncedAction
ActionThrottler() // ThrottledAction
ActionTimer() // TimedAction

ActionExecutor() // ExecutableAction
ActionTrigger() // TriggeringAction, MultipleTriggeringAction // Better name?

ModelSaver(path: URL, throttle: TimeInterval) // SavedModel

```

## 📦 Packaging

- List benefits of automatic sub-state selection for separating components into packages
- Views don’t need to know about any parent types from the tree so they can be in their own packages if desired
- Can make some of a component’s actions public and some private to the package
- Can create full component view previews with just the state in a package and no external top-down setup

## ✅ Testing

Test models by creating a store and sending actions to it. Use the store’s `find` method to query values.

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

Pass in alternate services to provide behaviour appropriate for your tests. Anything goes — no need to subclass or otherwise hijack your production services unless you want to.

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

let store = Store(model: Counter(), middleware: [FixedNumberFetcher()])
let store = Store(model: Counter(), middleware: [FailingNumberFetcher()])
```

## 💣 Escaping

- List escape hatches for code that uses global state
  - Pretty straightforward, just keep a global reference to the store and dispatch anywhere
  - Use one of the middleware to subscribe to changes, make it a singleton if you want
- Get and set state manually when needed
- Subscribe via callback to the store

## 💾 Installation

Install using Swift Package Manager with this repository’s URL

```
https://github.com/Substate/Substate.git
```

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
