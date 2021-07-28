import Foundation

/// A model which can be saved to persistent storage.
///
/// - Default implementations of all requirements are provided. They use JSONEncoder/JSONDecoder
/// - Ideally we’d just use codable directly and get rid of these methods but I can’t figure out how to pass the desired type into JSONDecoder.decode() using a variable containing the type.
///
public protocol SavedModel: Codable {

    /// A binary representation of this model for saving.
    ///
    var data: Data? { get }

    /// Initialise this model from a binary representation.
    ///
    init(from data: Data) throws

}
