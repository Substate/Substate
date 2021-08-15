///// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.
/////
public protocol Middleware {

    /// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.
    ///
    func update(send: @escaping Send, find: @escaping Find) -> (@escaping Send) -> Send

}
