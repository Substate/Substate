///// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.
/////
public protocol Middleware {

    /// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.
    ///
    @MainActor func configure(store: Store) -> (@escaping DispatchFunction) -> DispatchFunction

}
