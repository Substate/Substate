![Substate Icon](https://www.datocms-assets.com/15979/1626704059-substate-icon.svg)

# Substate

[![Build Status](https://github.com/substate/substate/actions/workflows/swift.yml/badge.svg)](https://github.com/Substate/Substate/actions)

Substate is a state management library for Swift.

## 🎚 States

```swift
import Substate
```

Let’s create a self-contained component. Describe the state you need using a simple value type.

```swift
struct Counter {
    var value = 0
}
```

Next, add some `Action`s to trigger state changes. They can be defined in any namespace, but it’s neat to keep them inside the state.

```swift
extension Counter {
    struct Increment: Action {}
    struct Decrement: Action {}
}
```

Then, conform to `State` by adding an `update` method. Define how the value should change when actions are received.

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

## 🎛 Sub-States

Add other states alongside plain values to compose a state tree for your program.

```swift
struct Counter: State {
    var value = 0
    var subCounter = SubCounter()

    mutating func update(action: Action) { ... }
}
```

Sub-states states are automatically detected and updated using their own `update` methods.

```swift
struct SubCounter: State {
    var value = 0

    mutating func update(action: Action) { ... }
}
```

## ⭐️ Views

```swift
import SubstateUI
```

Use the `Select` container to fetch your state inside views. Trigger actions by passing one into `update`.

```swift
struct CounterView: View {
    var body: some View {
        Select(Counter.self) { counter, update in
            Text("Counter Value: \(counter.value)")
            Button("Increment") { update(Counter.Increment()) }
        }
    }
}
```

Pass in another type to retrieve any sub-state you like from the tree.

```swift
struct SubCounterView: View {
    var body: some View {
        Select(SubCounter.self) { subCounter, update in
            Text("Sub-Counter Value: \(subCounter.value)")
            Button("Decrement") { update(Counter.Decrement()) }
        }
    }
}
```

## 🌟 Previews

Extend your state with convenience properties for different preview data.

```swift
extension Counter {
    static let zero = Counter(value: 0)
    static let random = Counter(value: .random(in: 1...100))
}
```

Pass in your predefined states to the `state` view modifier.

```swift
struct CounterViewPreviews: PreviewProvider {
    static var previews: some View {
        CounterView().state(Counter.zero)
        CounterView().state(Counter.random)
    }
}
```

> The `state` view modifier is an optional shorthand for `environmentObject(Store(state:))`.

## 🗄 Stores

Bootstrap your program by passing in your root state and a list of middleware to the `store` view modifier.

```swift
struct CounterApp: App {
    var scene: some Scene {
        CounterView().store(state: Counter(), middleware: [...])
    }
}
```

> The `store` view modifier is an optional shorthand for `enviromentObject(Store(state:middleware:))`.

For more control, create a store separately and retain it elsewhere.

```swift
let store = Store(state: Counter(), middleware: [...])
```

Retrieve sub-states directly from the store using its `select` method, passing in the desired type.

```swift
store.select(Counter.self) // => Optional<Counter>
store.select(SubCounter.self) // => Optional<SubCounter>
```

Trigger actions directly from the store using its `update` method, passing in the desired action.

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
let store = Store(state: Counter(), middleware: [ActionLogger(), StateLogger()])
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

let store = Store(state: Counter(), middleware: [ActionLogger(filter: true)]

store.update(Counter.Increment())
store.update(Counter.Decrement())
```

```
- Substate.Action: Counter.Decrement
```

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

```swift
Select(ActionLogger.State.self) { logger, update in
    Text("Logging: \(logger.isActive)")
    Button("Start") { update(ActionLogger.Start()) }
    Button("Stop") { update(ActionLogger.Stop()) }
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

StatePublisher() // PublishedState
ActionPublisher() // PublishedAction

StateLogger() // LoggedState
ActionLogger() // LoggedAction

StateRecorder() // RecordedState
ActionRecorder() // RecordedAction

ActionDelayer() // DelayedAction
ActionDebouncer() // DebouncedAction
ActionThrottler() // ThrottledAction
ActionTimer() // TimedAction

ActionExecutor() // ExecutableAction
ActionTrigger() // TriggeringAction, MultipleTriggeringAction // Better name?

StateSaver(path: URL, throttle: TimeInterval) // SavedState

```

## 📦 Packaging

- List benefits of automatic sub-state selection for separating components into packages
- Views don’t need to know about any parent types from the tree so they can be in their own packages if desired
- Can make some of a component’s actions public and some private to the package
- Can create full component view previews with just the state in a package and no external top-down setup

## ✅ Testing

Test states and sub-states by creating a store and sending actions to it. Use the store’s `select` method to query values.

```swift
func testCounter() throws {
    let store = Store(state: Counter())
    XCTAssertEqual(store.select(Counter.self)?.value, 0)

    store.update(Counter.Increment())
    XCTAssertEqual(store.select(Counter.self)?.value, 1)

    store.update(SubCounter.Increment())
    XCTAssertEqual(store.select(SubCounter.self)?.value, 1)
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

let store = Store(state: Counter(), services: [FixedNumberFetcher()])
let store = Store(state: Counter(), services: [FailingNumberFetcher()])
```

## 💣 Escaping

- List escape hatches for code that uses global state
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
