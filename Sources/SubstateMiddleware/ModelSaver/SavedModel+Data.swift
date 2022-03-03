//import Foundation
//
///// Helpers for marshalling a saved model to and from data.
/////
///// - Ideally we’d just use codable directly and get rid of these methods, but I can’t figure out
/////   how to pass the desired type into JSONDecoder.decode() at runtime.
/////
//public extension SavedModel {
//
//    /// Default implementation of `data` getter.
//    ///
//    /// - Uses JSON
//    ///
//    var data: Data? {
//        try? JSONEncoder().encode(self)
//    }
//
//    /// Default implementation of `init?(from:)` initialiser.
//    ///
//    /// - Uses JSON
//    ///
//    init(from data: Data) throws {
//        self = try JSONDecoder().decode(Self.self, from: data)
//    }
//
//}
