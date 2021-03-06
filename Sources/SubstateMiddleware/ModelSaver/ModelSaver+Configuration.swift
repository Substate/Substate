import Foundation
import Combine
import Substate

extension ModelSaver {

    /// Alter `ModelSaver`’s load and save behaviour.
    ///
    public struct Configuration: Model {

        // MARK: - Initialisation

        public init() {}

        public init(
            load: @escaping LoadFunction = initial.load,
            save: @escaping SaveFunction = initial.save,
            loadStrategy: LoadStrategy = initial.loadStrategy,
            saveStrategy: SaveStrategy = initial.saveStrategy
        ) {
            self.load = load
            self.save = save
            self.loadStrategy = loadStrategy
            self.saveStrategy = saveStrategy
        }

        /// The default initial configuration.
        ///
        public static let initial = Configuration()

        // MARK: - Members

        public var load: LoadFunction = defaultLoadFunction
        public var save: SaveFunction = defaultSaveFunction

        public var loadStrategy: LoadStrategy = .automatic
        public var saveStrategy: SaveStrategy = .debounced(0.25)

        // MARK: - Types

        public typealias LoadFunction = @Sendable (SavedModel.Type) async throws -> Model
        public typealias SaveFunction = @Sendable (SavedModel) async throws -> Void

        public enum LoadStrategy: Sendable {
            case manual
            case automatic
        }

        public enum SaveStrategy: Sendable {
            case manual
            case periodic(TimeInterval)
            case debounced(TimeInterval)
            case throttled(TimeInterval)
        }

        // MARK: - Update

        public struct Update: Action {
            let value: Configuration

            public init(value: Configuration) {
                self.value = value
            }
        }

        mutating public func update(action: Action) {
            if let action = action as? Update {
                self = action.value
            }
        }

    }

}
