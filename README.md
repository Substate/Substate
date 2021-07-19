![Substate Icon](https://www.datocms-assets.com/15979/1626704059-substate-icon.svg)

# Substate

Substate is a Redux-inspired state management library for Swift.

## 🎚 States

Let’s create a self-contained component. Describe the state you need using a simple value type.

```swift
struct Counter {
    var value = 0
}
```

Next, add some actions to trigger state changes. They can be defined in any namespace, but it’s neat to keep them inside the state.

```swift
extension Counter {
    struct Increment: Action {}
    struct Decrement: Action {}
    struct Reset: Action {}
}
```

Then, conform your state to `State` by adding an `update(action:)` method. Define how the value should change when actions are received.

```swift
extension Counter: State {
    mutating func update(action: Action) {
        switch action {
        case is Increment: value += 1
        case is Decrement: value -= 1
        case is Reset: value = 0
        default: ()
        }
    }
}
```

## 🎛 Sub-States

Add sub-states alongside plain values to compose a state tree for your program.

```swift
struct Counter: State {
    var value = 0
    var subCounter = SubCounter()

    mutating func update(action: Action) {
        // ...
    }
}
```

The child states are automatically detected and updated using their own `update(action:)` method. 

```swift
struct SubCounter: State {
    var value = 0

    mutating func update(action: Action) {
        // ...
    }
}
```

## ⭐️ Views

Use the `Substate` helper to grab your state inside views. Trigger actions by passing one into `dispatch`. 

```swift
struct CounterView: View {
    var body: some View {
        Substate(Counter.self) { counter, dispatch in
            Text("Counter Value: \(counter.value)")
            Button("Increment") { dispatch(Counter.Increment()) }
            Button("Decrement") { dispatch(Counter.Decrement()) }
        }
    }
}
```

Pass in another type to retrieve any sub-state you like from the tree.

```swift
struct SubCounterView: View {
    var body: some View {
        Substate(SubCounter.self) { subCounter, dispatch in
            Text("Sub-Counter Value: \(subCounter.value)")
            Button("Increment") { dispatch(SubCounter.Increment()) }
            Button("Decrement") { dispatch(SubCounter.Decrement()) }
        }
    }
}
```

## 🌟 Previews

Extend your state with convenience methods to see different data in previews.

```swift
extension Counter {
    static let zero = Counter(value: 0)
    static let random = Counter(value: .random(in: 1...100))
    static func with(value: Int) { Counter(value: value) }
}
```

Pass in your predefined states to the `state` view modifier (an optional shorthand for `environmentObject(Store(state:))`).

```swift
struct CounterViewPreviews: PreviewProvider {
    static var previews {
        Group {
            CounterView().state(Counter.zero)
            CounterView().state(Counter.random)
            CounterView().state(Counter.with(value: 100))
        }
    }
}
```

## 👷 Services

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

To bootstrap the program, pass in your root state and a list of services to the `store` view modifier (an optional shorthand for `enviromentObject(Store(state:services:))`).

```swift
struct CounterApp: App {
    var scene: some Scene {
        CounterView().store(state: Counter(), services: [...])
    }
}
```

For more control, create a store separately and retain it elsewhere.

```swift
let store = Store(state: Counter(), services: [...])
```

To retrieve sub-states directly from the store, call its `state` method and pass the desired type.

```swift
store.state(Counter.self) // => Optional<Counter>
store.state(SubCounter.self) // => Optional<SubCounter>
```

To dispatch actions directly to the store, call its `dispatch` method and pass in the desired action.

```swift
store.dispatch(Counter.Increment())
```

## 📦 Packages

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

## ✅ Testing

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

```swift
func testCounter() throws {
    let store = Store(state: Counter())
    XCTAssertEqual(store.substate(Counter.self)?.value, 0)
    XCTAssertEqual(store.substate(SubCounter.self)?.value, 0)

    store.dispatch(Counter.Increment())
    XCTAssertEqual(store.substate(Counter.self)?.value, 1)

    store.dispatch(SubCounter.Increment())
    XCTAssertEqual(store.substate(SubCounter.self)?.value, 1)
}
```

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

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

---

## Swift Concurrency Support

TODO.

```swift
protocol Service {
    func handle(action: Action) async -> Action // Or AsyncSequence?
}
```
