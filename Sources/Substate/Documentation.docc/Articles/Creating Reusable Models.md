# Creating Reusable Models

A model can be reused in more than one place by making it generic with respect to its container.

## Example

```swift
struct Tracker<Screen>: Model { ... }

struct NewsScreen: Model {
    var tracker = Tracker<NewsScreen>()
}

struct ProductsScreen: Model {
    var tracker = Tracker<ProductsScreen>()
}
```
