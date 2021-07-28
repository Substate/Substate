# ``Substate/Middleware``

Middleware overview.

```swift
func update(store: Store) -> (@escaping Update) -> Update {
    return { next in
        return { action in
            next(action) // Passthrough
        }
    }
}
```
