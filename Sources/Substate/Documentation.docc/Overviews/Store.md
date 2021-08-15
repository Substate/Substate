# ``Substate/Store``

Create a store, providing an initial root state and any middleware.

```swift
let store = Store(model: Counter(), middleware: [ActionLogger()])
```

Retrieve models from the store by passing the desired type to `find(_:)`:

```swift
store.find(Counter.self) // => Optional<Counter>
store.find(SubCounter.self) // => Optional<SubCounter>
```

Update your models by passing an action to `update(_:)`.

```swift
store.update(Counter.Increment())
// - Substate.Action: Example.Counter.Increment
```

## Topics

### Actions

- ``Start``
- ``Replace``
