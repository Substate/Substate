import Foundation

/// Helpers for marshalling a saved model to and from data.
///
/// - Ideally we’d just use codable directly and get rid of these methods.
/// - Think this issue is due to Swift not being able to 'open existentials' for generic use.
/// - See: https://forums.swift.org/t/pitch-implicitly-opening-existentials/55412/5
///
public extension SavedModel {

    /// Default implementation of `data` getter.
    ///
    /// - Uses JSON
    ///
    var data: Data? {
        try? JSONEncoder().encode(self)
    }

    /// Default implementation of `init?(from:)` initialiser.
    ///
    /// - Uses JSON
    ///
    init(from data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }

}
