import Combine
import Substate

/// A type representing a type-erased publisher of actions, and helpers.
///
/// Here we define a protocol that allows the result builder to automatically convert any conforming
/// publisher of actions to an `AnyActionPublisher`. It’s a little trick that allows us to capture
/// publisher chains in the builder without requiring the final `eraseToAnyPublisher()` step, which
/// cleans up the API somewhat.
///
/// It would be simpler to use a `buildExpression` overload that is generic over the publisher type,
/// and constrained on its output and failure types, but targetting this protocol instead has a nice
/// advantage in that it forces the compiler to assume the output of the last step in the combine
/// chain is `== Action` rather than `: Action`. This influences type inference further up in the
/// chain, and means you can mix and match concrete action types within the chain which is handy:
///
/// ```swift
/// publisher(for: SomeAction.self)
///     .tryMap { try something() }
///     .map { SuccessAction() } // No need to add `as Action`
///     .replaceError(with: FailureAction()) // Replacement doesn’t have to be the same type
/// ```

public typealias AnyActionPublisher = AnyPublisher<Action, Never>

public protocol AnyActionPublisherErasable {
    func eraseToAnyActionPublisher() -> AnyActionPublisher
}

extension Publisher where Output == Action, Failure == Never {
    public func eraseToAnyActionPublisher() -> AnyActionPublisher {
        AnyPublisher(self)
    }
}

// TODO: Conform other relevant publishers. Map and ReplaceError are the main useful ones.

extension Publishers.Map: AnyActionPublisherErasable where Output == Action, Failure == Never {}
extension Publishers.ReplaceError: AnyActionPublisherErasable where Output == Action {}
