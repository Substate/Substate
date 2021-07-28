import Foundation
import Substate

extension ModelSaver {

    // MARK: - Loading

    public struct Load: Action {
        public let type: Model.Type

        public init(_ type: Model.Type) {
            self.type = type
        }
    }

    public struct LoadDidSucceed: Action {
        public let type: Model.Type
        public let model: Model

        public init(for type: Model.Type, model: Model) {
            self.type = type
            self.model = model
        }
    }

    public struct LoadDidFail: Action {
        public let type: Model.Type
        public let error: LoadError

        public init(for type: Model.Type, with error: LoadError) {
            self.type = type
            self.error = error
        }
    }

    public struct LoadAll: Action {
        public init() {}
    }

    // MARK: - Saving

    public struct Save: Action {
        public let type: Model.Type

        public init(_ type: Model.Type) {
            self.type = type
        }
    }

    public struct SaveDidSucceed: Action {
        public let type: Model.Type

        public init(for type: Model.Type) {
            self.type = type
        }
    }

    public struct SaveDidFail: Action, Error {
        public let type: Model.Type
        public let error: SaveError

        public init(for type: Model.Type, with error: SaveError) {
            self.type = type
            self.error = error
        }
    }

    public struct SaveAll: Action {
        public init() {}
    }

}
