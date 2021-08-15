/// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.
///
/// - TODO: May be a better find API than this? Use find(AnyModel.self) rather than find(nil)?
/// - TODO: How can we put back the generics here, to get an array back with the actual type we want?
///
/// Perhaps:
///
/// ```
/// find(.all)
/// find(.root)
/// find(.model(Settings.self))
/// ```
///
public typealias Find = (Model.Type?) -> [Model]
