# ``Substate``

A tiny state management library for Swift. 

[![Banner](SubstateBanner)](https://substate.dev)

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.

[![Banner](SubstateUIBanner)](https://substate.netlify.app/documentation/substateui)

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.

[![Banner](SubstateMiddlewareBanner)](https://substate.netlify.app/documentation/substatemiddleware)

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.

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

Next, add some Actions that will trigger model updates. Define these within your model type to keep things organised.

```swift
extension Counter {
    struct Increment: Action {}
    struct Decrement: Action {}
}
```

Finally, conform to Model by adding an update(action:) method. Define how the value should change when actions are received.

```swift
extension Counter: Model {
    mutating func update(action: Action) {
        switch action {
        case is Increment: value += 1
        case is Decrement: value -= 1
        default: ()
        }
    }
}
```

---

Learn more about models:

- ``Model``
- <doc:Create-a-Model>
- <doc:Advanced-Model-Composition>

## 🎛 Nesting

Add other models alongside plain values to compose a state tree for your program.

```swift
struct Counter: Model {
    var value = 0
    var subCounter = SubCounter()
    mutating func update(action: Action) { ... }
}
```

Nested models are automatically detected and updated using their own update(action:) methods.

```swift
struct SubCounter: Model {
    var value = 0
    mutating func update(action: Action) { ... }
}
```

Reuse models in different places by making them generic with respect to their containers.

```swift
struct Tracker<Screen>: Model { ... }

struct NewsScreen: Model {
    var tracker = Tracker<NewsScreen>()
}

struct ProductsScreen: Model {
    var tracker = Tracker<ProductsScreen>()
}
```

## Toolkit

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.

![Mac App Screenshot](MacAppScreenshot)

> Note: At present, Substate is developed for and tested using iOS 14+ and macOS 11+. Greater platform and version support is planned pending more work on the CI setup.


## Topics

### Essentials

- <doc:Quick-Start>
- ``Store``
- ``Action``
- ``Model``
- ``Middleware``

### Articles

- <doc:Install-Substate>
- <doc:Create-a-Substate-App>
- <doc:Advanced-Model-Composition>
