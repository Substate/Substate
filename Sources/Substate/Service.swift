import Combine

public protocol Service: AnyObject {
    func handle(action: Action) -> AnyPublisher<Action, Never>?
}
