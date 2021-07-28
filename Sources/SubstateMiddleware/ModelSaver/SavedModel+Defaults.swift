import Foundation

public extension SavedModel {

    /// Default implementation of ID which uses the type name.
    ///
    /// - TODO: Sanitise some cases where String(describing:) produces junk strings
    ///
    static var id: String {
        String(describing: self)
    }

    /// Default implementation of `data` getter.
    ///
    /// - Uses JSON
    ///
    var data: Data? {
        try? encoder.encode(self)
    }

    /// Default implementation of `init?(from:)` initialiser.
    ///
    /// - Uses JSON
    ///
    init(from data: Data) throws {
        self = try decoder.decode(Self.self, from: data)
    }

}

private let encoder = JSONEncoder()
private let decoder = JSONDecoder()
