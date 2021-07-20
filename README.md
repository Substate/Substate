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

Use the `Select` container to fetch your state inside views. Trigger actions by passing one into `send`.

```swift
struct CounterView: View {
    var body: some View {
        Select(Counter.self) { counter, send in
            Text("Counter Value: \(counter.value)")
            Button("Increment") { send(Counter.Increment()) }
        }
    }
}
```

Pass in another type to retrieve any sub-state you like from the tree.

```swift
struct SubCounterView: View {
    var body: some View {
        Select(SubCounter.self) { subCounter, send in
            Text("Sub-Counter Value: \(subCounter.value)")
            Button("Decrement") { send(Counter.Decrement()) }
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

## 👷 Middleware

```swift
import SubstateMiddleware
```

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

```swift
LoggableMiddleware(filter: true)
SubstateAsyncMiddleware()
SubstateDelayedMiddleware()
SubstateFollowupMiddleware()
```

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

```swift
class NumberFetcher {
    func fetch(within range: Range<Int>) -> AnyPublisher<Int, Error> {
        // ...
    }
}
```

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

```swift
extension NumberFetcher: Service {
    func handle(action: Action) -> AnyPublisher<Action, Never>? {
        guard let action = action as? Numbers.Fetch else {
            return nil
        }

        return fetch(within: action.range)
            .map(Numbers.FetchDidSuceed.init(number:))
            .catch(Numbers.FetchDidFail.init(error:))
            .eraseToAnyPublisher()
    }
}
```

## 🗄 Stores

To bootstrap the program, pass in your root state and a list of services to the `store` view modifier.

```swift
struct CounterApp: App {
    var scene: some Scene {
        CounterView().store(state: Counter(), services: [...])
    }
}
```

> The `store` view modifier is an optional shorthand for `enviromentObject(Store(state:services:))`.

For more control, create a store separately and retain it elsewhere.

```swift
let store = Store(state: Counter(), services: [...])
```

To retrieve sub-states directly from the store, call its `select` method and pass the desired type.

```swift
store.select(Counter.self) // => Optional<Counter>
store.select(SubCounter.self) // => Optional<SubCounter>
```

To trigger actions directly from the store, call its `send` method and pass in the desired action.

```swift
store.send(Counter.Increment())
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

    store.send(Counter.Increment())
    XCTAssertEqual(store.select(Counter.self)?.value, 1)

    store.send(SubCounter.Increment())
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
