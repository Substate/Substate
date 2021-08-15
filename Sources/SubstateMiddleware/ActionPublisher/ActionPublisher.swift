import Combine
import Substate

public class ActionPublisher: Middleware {

    public init() {}

    private let publisher = PassthroughSubject<Action, Never>()
    private var subscriptions: [AnyCancellable] = []

    public func update(send: @escaping Send, find: Find) -> (@escaping Send) -> Send {
        return { next in
            return { action in
                self.publisher.send(action)
                next(action)
            }
        }
    }

    public func publisher<A:Action>(for action: A.Type) -> AnyPublisher<A, Never> {
        publisher.compactMap { $0 as? A }.eraseToAnyPublisher()
    }

    public func callback<A:Action>(for action: A.Type, callback: @escaping (A) -> Void) {
        publisher(for: action).sink(receiveValue: callback).store(in: &subscriptions)
    }

}
