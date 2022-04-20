import Combine
import Substate

extension ActionStream {

    // MARK: - Actions

    /// Publisher for an action.
    ///
    /// ```
    /// stream.publisher(for: MyAction.self)
    /// ```
    public func publisher<A>(for: A.Type) -> AnyPublisher<A, Never>
    where A : Action {
        publisher
            .compactMap { $0 as? A }
            .eraseToAnyPublisher()
    }

    // MARK: - Values

    /// Publisher for a model value.
    ///
    /// ```
    /// stream.publisher(for: \User.name)
    /// ```
    ///
    public func publisher<M, V>(for keyPath: KeyPath<M, V>) -> AnyPublisher<V, Never>
    where M : Model, V : Equatable & Sendable {
        publisher
            .compactMap { _ -> V? in
                self.store?.find(M.self)?[keyPath: keyPath]
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    // MARK: - Actions + Values

    /// Publisher for an action and 1 model value.
    ///
    /// ```
    /// stream.publisher(for: MyAction.self, with: \MyModel.value)
    /// ```
    ///
    public func publisher<A, M, V>(for action: A.Type, with value1: KeyPath<M, V>) -> AnyPublisher<(A, V), Never>
    where A : Action, M : Model, V : Equatable & Sendable {
        publisher
            .compactMap { action in
                action as? A
            }
            .compactMap { action -> (A, V)? in
                guard let value = self.store?.find(M.self)?[keyPath: value1] else {
                    return nil
                }

                return (action, value)
            }
            .eraseToAnyPublisher()
    }

    /// Publisher for an action and 2 model values.
    ///
    /// ```
    /// stream.publisher(for: MyAction.self, with: \MyModel.value, \MyModel.value)
    /// ```
    ///
    public func publisher<A, M1, M2, V1, V2>(for action: A.Type, with value1: KeyPath<M1, V1>, _ value2: KeyPath<M2, V2>) -> AnyPublisher<(A, V1, V2), Never>
    where A : Action, M1 : Model, M2: Model, V1 : Equatable & Sendable, V2 : Equatable & Sendable {
        publisher
            .compactMap { action in
                action as? A
            }
            .compactMap { action -> (A, V1, V2)? in
                guard let value1 = self.store?.find(M1.self)?[keyPath: value1] else {
                    return nil
                }

                guard let value2 = self.store?.find(M2.self)?[keyPath: value2] else {
                    return nil
                }

                return (action, value1, value2)
            }
            .eraseToAnyPublisher()
    }

    /// Publisher for an action and 3 model values.
    ///
    /// ```
    /// stream.publisher(for: MyAction.self, with: \MyModel.value, \MyModel.value, \MyModel.value)
    /// ```
    ///
    public func publisher<A, M1, M2, M3, V1, V2, V3>(for action: A.Type, with value1: KeyPath<M1, V1>, _ value2: KeyPath<M2, V2>, _ value3: KeyPath<M3, V3>) -> AnyPublisher<(A, V1, V2, V3), Never>
    where A : Action, M1 : Model, M2 : Model, M3 : Model, V1 : Equatable & Sendable, V2 : Equatable & Sendable, V3 : Equatable & Sendable {
        publisher
            .compactMap { action in
                action as? A
            }
            .compactMap { action -> (A, V1, V2, V3)? in
                guard let value1 = self.store?.find(M1.self)?[keyPath: value1] else {
                    return nil
                }

                guard let value2 = self.store?.find(M2.self)?[keyPath: value2] else {
                    return nil
                }

                guard let value3 = self.store?.find(M3.self)?[keyPath: value3] else {
                    return nil
                }

                return (action, value1, value2, value3)
            }
            .eraseToAnyPublisher()
    }

}
