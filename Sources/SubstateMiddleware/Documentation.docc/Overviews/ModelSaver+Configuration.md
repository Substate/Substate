# ``SubstateMiddleware/ModelSaver/Configuration``

## Loading

Loading of models is automatic by default, meaning all models are loaded when `ModelSaver` is initialised. Loading can be changed to manual, leaving it up to you to load some or all models whenever you want. In either case, manual loads can still be performed at any time.

```swift
let configuration = ModelSaver.Configuration(loadStrategy: .manual)
```

The loading method itself can be fully customised by swapping out the `LoadFunction`.

```swift
let configuration = ModelSaver.Configuration(load: { type in
    // Fetch the given type from persistent storage
    // Return it via AnyPublisher<Model, LoadError>
})
```

- ``ModelSaver/Configuration/LoadStrategy-swift.enum``
- ``ModelSaver/Configuration/LoadFunction``

## Saving

Saving of models uses the `debounced` strategy by default, which triggers saving after a given idle interval after a stream of actions are received to avoid flooding the system with saves. It can be changed to `throttle`, which is similar (see the Combine docs), to `manual`, or to `periodic`, which simply saves every `n` seconds.

```swift
let configuration = ModelSaver.Configuration(saveStrategy: .periodic(30))
```

The saving method itself can be fully customised by swapping out the `SaveFunction`.

```swift
let configuration = ModelSaver.Configuration(save: { model in
    // Save the model value to persistent storage
    // Return any errors via AnyPublisher<Void, SaveError>
})
```

- ``ModelSaver/Configuration/SaveStrategy-swift.enum``
- ``ModelSaver/Configuration/SaveFunction``

## Updating

Updating of models after a successful load is done automatically by default. This can be changed to manual if more control over the update process is desired — the automatic strategy employs `Store.Replace` to replace a loaded model wholesale with no update logic, which is an easy default but may not be desired (for example if you wanted a model with a `lastLoadedAt` timestamp which would be updated on load). In the manual case, your models will need to act on the ``ModelSaver/LoadDidSucceed`` action and update themselves.

```swift
let configuration = ModelSaver.Configuration(updateStrategy: .manual)
```

- ``ModelSaver/Configuration/UpdateStrategy-swift.enum``

- TODO: Caching filter to avoid saving models that didn’t change since they were last saved?
- TODO: Add section on `Update` — as in the action that causes this configuration to be updated

## Topics

### Actions

- ``Update``
