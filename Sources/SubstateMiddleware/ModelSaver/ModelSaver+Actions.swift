import Foundation
import Substate

extension ModelSaver {

    struct Setup: Action {}

    // MARK: - Loading

    /// Load a model from persistent storage.
    ///
    public struct Load: Action {
        public let type: Model.Type

        public init(_ type: Model.Type) {
            self.type = type
        }
    }

    /// Loading a model from persistent storage succeeded.
    ///
    public struct LoadDidSucceed: Action {
        public let model: Model

        public init(with model: Model) {
            self.model = model
        }
    }

    /// Loading a model from persistent storage failed.
    ///
    public struct LoadDidFail: Action {
        public let type: Model.Type
        public let error: LoadError

        public init(for type: Model.Type, with error: LoadError) {
            self.type = type
            self.error = error
        }
    }

    /// Automatic update of a loaded model completed.
    /// 
    public struct UpdateDidComplete: Action {
        public let type: Model.Type
    }

    /// Load all `SavedModel`s from persistent storage.
    ///
    public struct LoadAll: Action {
        public init() {}
    }

    // MARK: - Saving

    /// Save a model to persistent storage.
    ///
    public struct Save: Action {
        public let type: Model.Type

        public init<T>(_ type: T.Type) where T: Model, T: SavedModel {
            self.type = type
        }
    }

    /// Saving a model to persistent storage succeeded.
    ///
    public struct SaveDidSucceed: Action {
        public let type: Model.Type

        public init(for type: Model.Type) {
            self.type = type
        }
    }

    /// Saving a model to persistent storage failed.
    ///
    public struct SaveDidFail: Action, Error {
        public let type: Model.Type
        public let error: SaveError

        public init(for type: Model.Type, with error: SaveError) {
            self.type = type
            self.error = error
        }
    }

    /// Save all `SavedModel`s to persistent storage.
    /// 
    public struct SaveAll: Action {
        public init() {}
    }

}
