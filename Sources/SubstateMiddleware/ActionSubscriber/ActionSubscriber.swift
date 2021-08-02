/// A pseudo-middleware.
/// Defines an interface that other objects can adopt (eg. a sound effect player, network request maker)
///
/// Existing objects confirm, and can then be passed in as a middleware
/// Would just need to add a method or two, eg. to catch actions
///
/// What about sending actions back? Is that allowed? Handle making sure they don’t keep a strong reference to the store?
///
/// protocol ActionSubscriber {
///    func setup() {}
///    func handle(action: Action) { ... }
/// }
///
/// Hmmmm the above looks pretty similar to the actual middleware interface. Is this worth it?
/// Is it easy enough for services to apply to be a middleware? Could this be termed more of a
/// 'middleware lite'?
///
