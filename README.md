# Substate

Substate is a Redux-inspired state management library for Swift.

## States

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

```swift
struct Counter: State {
    var value = 0
}
```

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore. Mention ability to separate actions by module/package, or share them by making some actions public.

No need to put the actions under the state type’s namespace, but it’s a nice convention because within the type you can refer to the actions concisely without qualifying the namespace, but outside you must use the full name (eg. `Counter.Increment()`) which clarifies intent elsewhere.

```swift
extension Counter {
    struct Increment: Action {}
    struct Decrement: Action {}
    struct Reset: Action {}
}
```

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

```swift
extension Counter {
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

## Sub-States

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

```swift
struct Counter: State {
    var value = 0
    var subCounter = SubCounter()

    mutating func update(action: Action) {
        // ...
    }
}
```

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore. Mention all sub-states of any depth are picked up and their update functions run automatically, with no manual composing of 'reducers' as in other libraries.

```swift
struct SubCounter: State {
    var value = 0

    mutating func update(action: Action) {
        // ...
    }
}
```

Mention ability to put sub-states in different packages with no mutual access.

## Views

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

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

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

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

Mention that because the view helper automatically fetches the specified sub-state, views don’t need to know about types higher up in the state tree, and therefore can be nicely separated into packages without any knowledge of other unrelated state types.

## Previews

Extend your models with convenience methods for states that you want to visualise in view previews.

```swift
extension Counter {
    static let zero = Counter(value: 0)
    static let random = Counter(value: .random(in: 1...100))
    static func with(value: Int) { Counter(value: value) }
}
```

Pass in your predefined states to the `substate()` view modifier. (This is just an optional shorthand for `environmentObject(Store(state:))`).

```swift
struct CounterViewPreviews: PreviewProvider {
    static var previews {
        Group {
            CounterView().substate(Counter.zeroed)
            CounterView().substate(Counter.random)
            CounterView().substate(Counter.with(value: 100))
        }
    }
}
```

## Services

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

## Stores

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

```swift
let store = Store(state: Counter(), services: [...])
```

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.

```swift
struct CounterApp: App {
    let store = Store(state: Counter(), services: [...])

    var scene: some Scene {
        CounterView().environmentObject(store)
    }
}
```

To retrieve sub-states directly from a store, call its `substate()` method and pass the desired sub-state type. If no sub-state of the given type is present in the store’s state tree, `nil` is returned.

```swift
let store = Store(state: Counter())

store.substate(Counter.self) // => Optional<Counter>
store.substate(SubCounter.self) // => Optional<SubCounter>
```

## Testing

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

## Swift Concurrency Support

TODO.

```swift
protocol Service {
    func handle(action: Action) async -> Action // Or AsyncSequence?
}
```
