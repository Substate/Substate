public typealias UpdateFunction = (Action) -> Void

public protocol Middleware {
    func setup(store: Store)
    func update(store: Store) -> (@escaping UpdateFunction) -> UpdateFunction
}

