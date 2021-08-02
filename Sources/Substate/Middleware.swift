/// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.
///
/// - TODO: Really need to think about whether we should pass the store in directly to the setup
/// and update methods. Can we reduce the API surface area of Store that middleware use and bring it
/// down to a couple of functions that get passed in? Then again full access to the store does enable
/// some really powerful behaviour. One way to bridge the gap may be to improve the API for finding
/// models. At present there is find(type:) and allModels. Maybe we could introduce an AnyModel
/// to be used to select all models, and provide an overload of find(type:) that returns an array?
/// Then we’d be a step closer to being able to just provide a (non-store-retaining) function that
/// returns models rather than the full store.
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
