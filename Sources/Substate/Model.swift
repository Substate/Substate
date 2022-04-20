/// Models are units of updateable state in your application.
///
/// - TODO: Enforce Codable conformance for all models.
///
public protocol Model: Sendable {

    /// A definition of how the model updates its state when an action is received.
    ///
    mutating func update(action: Action)

}
