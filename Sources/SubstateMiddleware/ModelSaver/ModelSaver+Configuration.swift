import Foundation
import Combine
import Substate

extension ModelSaver {

    /// Configuration options for ModelSaver.
    ///
    /// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt
    /// ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco
    /// laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in.
    ///
    /// ```swift
    /// // Override the save strategy
    /// let configuration = ModelSaver.Configuration(saveStrategy: .debounced(5))
    /// ```
    ///
    /// ```swift
    /// // Provide a custom function for loading models remotely
    /// let configuration = ModelSaver.Configuration(load: { id in
    ///     Just(id)
    ///         .flatMap { CloudService.fetch(id: id) }
    ///         .mapError { error in ModelSaver.LoadError.other($0) }
    ///         .receive(on: DispatchQueue.main }
    ///         .eraseToAnyPublisher()
    /// })
    /// ```
    ///
    /// ```swift
    /// // Create a new ModelSaver with a custom configuration
    /// let saver = ModelSaver(configuration: .init(saveStrategy: .debounced(5)))
    /// ```
    ///
    /// - TODO: Caching filter to avoid saving models that didn’t change since they were last saved?
    ///
    public struct Configuration: Model {

        // MARK: - Initialisation

        public init() {}

        public init(
            load: @escaping LoadFunction = initial.load,
            save: @escaping SaveFunction = initial.save,
            loadStrategy: LoadStrategy = initial.loadStrategy,
            saveStrategy: SaveStrategy = initial.saveStrategy) {
            self.load = load
            self.save = save
            self.loadStrategy = loadStrategy
            self.saveStrategy = saveStrategy
        }

        public static let initial = Configuration()

        // MARK: - Members

        public var load: LoadFunction = defaultLoadFunction
        public var save: SaveFunction = defaultSaveFunction

        public var loadStrategy: LoadStrategy = .automatic
        public var saveStrategy: SaveStrategy = .debounced(5)

        // MARK: - Types

        public typealias LoadFunction = (SavedModel.Type) -> AnyPublisher<Model, LoadError>
        public typealias SaveFunction = (SavedModel) -> AnyPublisher<Void, SaveError>

        public enum LoadStrategy {
            case manual
            case automatic
        }

        public enum SaveStrategy {
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
