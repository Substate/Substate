/// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.
///
/// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut
/// labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco
/// laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in
/// voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat
/// non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
///
public protocol Middleware {

    /// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.
    ///
    var model: Model? { get }

    /// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.
    ///
    func setup(store: Store)

    /// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.
    ///
    /// ```swift
    /// func update(store: Store) -> (@escaping UpdateFunction) -> UpdateFunction {
    ///     return { next in
    ///         return { action in
    ///             next(action) // Passthrough
    ///         }
    ///     }
    /// }
    /// ```
    ///
    func update(store: Store) -> (@escaping Update) -> Update

}
