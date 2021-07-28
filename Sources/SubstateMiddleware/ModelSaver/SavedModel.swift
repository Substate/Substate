import Foundation

/// A type designating a model which can be saved.
///
/// - Default implementations of all requirements are provided.
///
/// ```swift
/// struct Counter: Model, SavedModel {
///     var value = 0
///     mutating func update(action: Action) { ... }
/// }
/// ```
///
public protocol SavedModel: Codable {

    typealias ID = String

    /// An identifier unique to this model type.
    ///
    static var id: ID { get }

    /// A binary representation of this model for saving.
    ///
    var data: Data? { get }

    /// Initialise this model from a binary representation.
    ///
    init(from data: Data) throws

}
