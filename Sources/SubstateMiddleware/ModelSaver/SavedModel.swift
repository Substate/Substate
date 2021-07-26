import Foundation

/// A type designating a model which can be saved.
///
/// - Default implementations of all requirements are provided for `Codable` models.
///
/// ```swift
/// struct Counter: Model, SavedModel, Codable {
///     var value = 0
///     mutating func update(action: Action) { ... }
/// }
/// ```
///
public protocol SavedModel {

    typealias ID = String

    /// An identifier unique to this model type.
    ///
    static var id: ID { get }

    /// A binary representation of this model for saving.
    ///
    var data: Data? { get }

    /// Initialise this model from a binary representation.
    ///
    init?(from data: Data)

}

public extension SavedModel {

    /// Default implementation of ID which uses the type name.
    ///
    /// - TODO: Sanitise some cases where String(describing:) produces junk strings
    ///
    static var id: String {
        String(describing: self)
    }

}
