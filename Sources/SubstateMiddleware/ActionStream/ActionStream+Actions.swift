import Combine
import Substate

extension Action {

    // MARK: - Actions

    /// Subscribe to an action.
    ///
    /// ```
    /// MyAction.subscribe(on: stream)
    /// ```
    @MainActor public static func subscribe(on stream: ActionStream) -> AnyPublisher<Self, Never> {
        stream.publisher(for: Self.self)
    }

    /// Subscribe to an action, ignoring its value.
    ///
    /// ```
    /// MyAction.subscribe(on: stream)
    /// ```
    @MainActor public static func subscribe(on stream: ActionStream) -> AnyPublisher<Void, Never> {
        stream.publisher(for: Self.self)
            .map { _ in }
            .eraseToAnyPublisher()
    }

    // MARK: - Actions + Values

    /// Subscribe to an action and 1 model value.
    ///
    /// ```
    /// MyAction.subscribe(on: stream, with: \MyModel.value)
    /// ```
    ///
    @MainActor public static func subscribe<M1, V1>(on stream: ActionStream, with value1: KeyPath<M1, V1>) -> AnyPublisher<(Self, V1), Never>
    where M1 : Model, V1 : Equatable & Sendable {
        stream.publisher(for: Self.self, with: value1)
    }

    /// Subscribe to an action and 2 model values.
    ///
    /// ```
    /// MyAction.subscribe(on: stream, with: \MyModel.value, \MyModel.value)
    /// ```
    ///
    @MainActor public static func subscribe<M1, M2, V1, V2>(on stream: ActionStream, with value1: KeyPath<M1, V1>, _ value2: KeyPath<M2, V2>) -> AnyPublisher<(Self, V1, V2), Never>
    where M1 : Model, M2 : Model, V1 : Equatable & Sendable, V2 : Equatable & Sendable {
        stream.publisher(for: Self.self, with: value1, value2)
    }

    /// Subscribe to an action and 3 model values.
    ///
    /// ```
    /// MyAction.subscribe(on: stream, with: \MyModel.value, \MyModel.value, \MyModel.value)
    /// ```
    ///
    @MainActor public static func subscribe<M1, M2, M3, V1, V2, V3>(on stream: ActionStream, with value1: KeyPath<M1, V1>, _ value2: KeyPath<M2, V2>, _ value3: KeyPath<M3, V3>) -> AnyPublisher<(Self, V1, V2, V3), Never>
    where M1 : Model, M2 : Model, M3 : Model, V1 : Equatable & Sendable, V2 : Equatable & Sendable, V3 : Equatable & Sendable {
        stream.publisher(for: Self.self, with: value1, value2, value3)
    }

    // MARK: - Actions + Values (Ignoring Action)

    /// Subscribe to an action and 1 model value, ignoring the action’s value.
    ///
    /// ```
    /// MyAction.subscribe(on: stream, with: \MyModel.value)
    /// ```
    ///
    @MainActor public static func subscribe<M1, V1>(on stream: ActionStream, with value1: KeyPath<M1, V1>) -> AnyPublisher<V1, Never>
    where M1 : Model, V1 : Equatable & Sendable {
        stream.publisher(for: Self.self, with: value1)
            .map { _, model in model }
            .eraseToAnyPublisher()
    }

    /// Subscribe to an action and 2 model values, ignoring the action’s value.
    ///
    /// ```
    /// MyAction.subscribe(on: stream, with: \MyModel.value, \MyModel.value)
    /// ```
    ///
    @MainActor public static func subscribe<M1, M2, V1, V2>(on stream: ActionStream, with value1: KeyPath<M1, V1>, _ value2: KeyPath<M2, V2>) -> AnyPublisher<(V1, V2), Never>
    where M1 : Model, M2 : Model, V1 : Equatable & Sendable, V2 : Equatable & Sendable {
        stream.publisher(for: Self.self, with: value1, value2)
            .map { _, model1, model2 in (model1, model2) }
            .eraseToAnyPublisher()
    }

    /// Subscribe to an action and 3 model values, ignoring the action’s value.
    ///
    /// ```
    /// MyAction.subscribe(on: stream, with: \MyModel.value, \MyModel.value, \MyModel.value)
    /// ```
    ///
    @MainActor public static func subscribe<M1, M2, M3, V1, V2, V3>(on stream: ActionStream, with value1: KeyPath<M1, V1>, _ value2: KeyPath<M2, V2>, _ value3: KeyPath<M3, V3>) -> AnyPublisher<(V1, V2, V3), Never>
    where M1 : Model, M2 : Model, M3 : Model, V1 : Equatable & Sendable, V2 : Equatable & Sendable, V3 : Equatable & Sendable {
        stream.publisher(for: Self.self, with: value1, value2, value3)
            .map { _, model1, model2, model3 in (model1, model2, model3) }
            .eraseToAnyPublisher()
    }

}
