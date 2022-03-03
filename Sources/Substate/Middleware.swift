///// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.
/////
public protocol Middleware {

    /// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.
    ///
    func configure(store: Store) -> (@escaping DispatchFunction) -> DispatchFunction

}
