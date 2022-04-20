import Combine
import Substate

extension Model where Self : Equatable {

    /// Subscribe to a model.
    ///
    /// ```
    /// MyModel.subscribe(on: stream)
    /// ```
    @MainActor public static func subscribe(on stream: ActionStream) -> AnyPublisher<Self, Never> {
        stream.publisher(for: \Self.self)
    }

}

extension KeyPath where Root : Model, Value : Equatable & Sendable {

    // MARK: - Values

    /// Subscription for a model value.
    ///
    /// ```
    /// (\MyModel.value).subscribe(on: stream)
    /// ```
    @MainActor public func subscribe(on stream: ActionStream) -> AnyPublisher<Value, Never> {
        stream.publisher(for: self)
    }

}
