public typealias UpdateFunction = (Action) -> Void

public protocol Middleware {

    // TODO: Some work on naming this whole setup
    static var initialInternalState: State? { get }

    func setup(store: Store)
    func update(store: Store) -> (@escaping UpdateFunction) -> UpdateFunction

}
