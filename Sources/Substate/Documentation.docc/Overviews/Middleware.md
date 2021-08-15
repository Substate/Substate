# ``Substate/Middleware``

Middleware overview.

```swift
func update(send: @escaping Send, find: @escaping Find) -> (@escaping Send) -> Send
    return { next in
        return { action in
            next(action) // Passthrough
        }
    }
}
```
