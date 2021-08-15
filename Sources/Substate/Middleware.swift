///// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.
/////
public protocol Middleware {

    /// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.
    ///
    func update(update: @escaping Update, find: @escaping Find) -> (@escaping Update) -> Update

}
