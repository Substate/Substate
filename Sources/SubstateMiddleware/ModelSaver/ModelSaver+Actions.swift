import Foundation
import Substate

extension ModelSaver {

    // MARK: - Loading

    public struct Load: Action {
        public let type: Model.Type
        public init(_ type: Model.Type) { self.type = type }
    }

    public struct LoadAll: Action {
        public init() {}
    }

    // MARK: - Saving

    public struct Save: Action {
        public let type: Model.Type
        public init(_ type: Model.Type) { self.type = type }
    }

    public struct SaveAll: Action {
        public init() {}
    }

    public struct SaveDidSucceed: Action {
        public let type: Model.Type
    }

    public struct SaveDidFail: Action, Error {
        public let type: Model.Type
        public let error: SaveError
    }

}
