/// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.
///
public protocol Middleware {

    /// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.
    /// 
    typealias Update = (Action) -> Void

    /// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.
    ///
    var model: Model? { get }

    /// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.
    ///
    func setup(store: Store)

    /// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.
    ///
    func update(store: Store) -> (@escaping Update) -> Update

}
