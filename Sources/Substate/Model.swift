/// Models are units of updateable state in your application.
///
public protocol Model {

    /// A definition of how the model updates its state when an action is received.
    ///
    mutating func update(action: Action)

}

typealias ModelArray = [Model]

extension ModelArray: Model {
    public mutating func update(action: Action) {
        indices.forEach { self[$0].update(action: action) }
    }
}
