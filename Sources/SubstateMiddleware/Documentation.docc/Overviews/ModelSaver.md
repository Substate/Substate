# ``SubstateMiddleware/ModelSaver``

`ModelSaver` catches `SavedModels` and automatically loads and saves them. To start, conform one of your models to `SavedModel`.

```swift
struct Counter: Model, SavedModel { ... }
```

Create a store and add `ModelSaver()` to the middleware stack. By default, all `SavedModel`s will be loaded and replaced in the store after initialisation.

```swift
let store = Store(model: Counter(), middleware: [ActionLogger(), ModelSaver()])
// - Substate.Action: SubstateMiddleware.ModelSaver.LoadAll
// - Substate.Action: SubstateMiddleware.ModelSaver.LoadDidSucceed
// - Substate.Action: Substate.Store.Replace
```

Trigger any other action. After a short delay, a save will occur.

```swift
store.update(Counter.Increment())
// - Substate.Action: Example.Counter.Increment
// ...
// - Substate.Action: SubstateMiddleware.ModelSaver.Save
// - Substate.Action: SubstateMiddleware.ModelSaver.SaveDidSucceed
```

Trigger a save on a model manually.

```swift
store.update(ModelSaver.Save(Counter.self))
// - Substate.Action: SubstateMiddleware.ModelSaver.Save
// - Substate.Action: SubstateMiddleware.ModelSaver.SaveDidSucceed
```

## Customisation

Load and save behaviour can be fully customised using the ``init(configuration:)`` initialiser.

```swift
let saver = ModelSaver(configuration: .init(saveStrategy: .periodic(30)))
```

- ``ModelSaver/Configuration``

## Topics

### Models

- ``SavedModel``

### Actions

- ``Load``
- ``LoadAll``
- ``LoadDidFail``
- ``LoadDidSucceed``

- ``Save``
- ``SaveAll``
- ``SaveDidFail``
- ``SaveDidSucceed``

### Configuration

- ``ModelSaver/Configuration``
