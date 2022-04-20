import Combine
import Substate
import Foundation

extension ActionStream {

    @MainActor @resultBuilder public struct Builder {

        public typealias Item = (ActionStream) -> AnyCancellable

        /// Catch type-erased publishers of actions.
        ///
        /// ```
        /// publisher(for: MyAction.self)
        ///     .map { ... }
        ///     .eraseToAnyPublisher()
        /// ```
        ///
        public static func buildExpression(_ publisher: AnyPublisher<Action, Never>) -> Item {
            { stream in
                publisher
                    .receive(on: DispatchQueue.main)
                    .sink { stream.store?.dispatch($0) }
            }
        }

        /// Catch any already-subscribed publishers to enable side effects.
        ///
        /// ```
        /// publisher(for: \MyModel.value)
        ///     .sink { ... }
        /// ```
        public static func buildExpression(_ cancellable: AnyCancellable) -> Item {
            { stream in cancellable }
        }

        /// Build the final list of items.
        ///
        public static func buildBlock(_ items: Item...) -> [Item] {
            items
        }

    }

}
