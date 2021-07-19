import Combine

public protocol Service: AnyObject {
    // Can these be useful unless we pass in the state?
    // How can we specify what state the service wants; it can’t know about parent states!
    func handle(action: Action) -> AnyPublisher<Action, Never>?
}
