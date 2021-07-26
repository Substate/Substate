import Foundation
import Combine
import Substate

extension ModelSaver {

    public struct Configuration: Model {

        public var save: SaveFunction = defaultSaveFunction
        public var load: LoadFunction = defaultLoadFunction

        var loadAllOnInit = false
        var saveTimeStrategy: SaveStrategy = .debounced(5)

        public init() {}

        public typealias SaveFunction = (SavedModel) -> AnyPublisher<Void, Error>
        public typealias LoadFunction = (SavedModel.ID) -> AnyPublisher<Data, Error>

        public enum SaveStrategy {
            case manual
            case periodic(TimeInterval)
            case debounced(TimeInterval)
            case throttled(TimeInterval)
        }

        public struct Update: Action {
            let value: Configuration
            public init(value: Configuration) {
                self.value = value
            }
        }

        public static let initial = Configuration()

        mutating public func update(action: Action) {
            if let action = action as? Update {
                self = action.value
            }
        }

    }

}

extension ModelSaver.Configuration {

    // MARK: - Default Save & Load Implementation

    private static func defaultSaveFunction(model: SavedModel) -> AnyPublisher<Void, Error> {
        print("DEFAULT SAVE FN CALLED")

        do { try manager.createDirectory(at: folder, withIntermediateDirectories: true) } catch let error {
            return Fail(error: ModelSaver.SaveError.folderCouldNotBeCreated(error))
                .eraseToAnyPublisher()
        }

        guard let data = model.data else {
            return Fail(error: ModelSaver.SaveError.noDataProduced)
                .eraseToAnyPublisher()
        }

        return Just((data, url(for: model)))
            .tryMap { data, url in
                try data.write(to: url)
            }
            .mapError { error in
                ModelSaver.SaveError.unknown(error)
            }
            .eraseToAnyPublisher()
    }

    private static func defaultLoadFunction(id: SavedModel.ID) -> AnyPublisher<Data, Error> {
        print("DEFAULT LOAD FN CALLED")
        return Just(Data()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    private static func url(for model: SavedModel) -> URL {
        folder.appendingPathComponent(name(for: model))
    }

    private static func name(for model: SavedModel) -> String {
        String(describing: type(of: model)) + ".json"
    }

    private static var folder: URL {
        manager
            .urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("Substate")
    }

    private static var manager: FileManager { .default }

}
