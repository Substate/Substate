import Foundation
import CryptoKit

/// Helpers for marshalling a saved model to and from data.
///
/// - Ideally we’d just use codable directly and get rid of these methods.
/// - Think this issue is due to Swift not being able to 'open existentials' for generic use.
/// - See: https://forums.swift.org/t/pitch-implicitly-opening-existentials/55412/5
///
extension SavedModel {

    /// Default implementation of `data` getter.
    ///
    /// - Uses JSON
    ///
    public var data: Data? {
        try? JSONEncoder().encode(self)
    }

    /// Default implementation of `init?(from:)` initialiser.
    ///
    /// - Uses JSON
    ///
    public init(from data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }

    /// An internal ID used for the save de-duplication cache.
    ///
    internal var saveCacheId: String {
        String(describing: Self.self)
    }

    /// An internal content hash used for the save de-duplication cache.
    ///
    internal var saveCacheHash: SHA256Digest? {
        data.map(SHA256.hash)
    }

}
