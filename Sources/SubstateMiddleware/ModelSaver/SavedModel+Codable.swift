import Foundation

public extension SavedModel where Self: Encodable {

    /// Default implementation of `data` getter for `Encodable` models.
    ///
    /// - Uses JSON
    ///
    var data: Data? {
        try? encoder.encode(self)
    }

}

public extension SavedModel where Self: Decodable {

    /// Default implementation of `init?(from:)` initialiser for `Decodable` models.
    ///
    /// - Uses JSON
    ///
    init?(from data: Data) {
        guard let model = try? decoder.decode(Self.self, from: data) else {
            return nil
        }

        self = model
    }

}

private let encoder = JSONEncoder()
private let decoder = JSONDecoder()
