//import Foundation
//import Combine
//import Substate
//
//extension ModelSaver.Configuration {
//
//    // MARK: - Default Implementations
//
//    static func defaultSaveFunction(model: SavedModel) -> AnyPublisher<Void, ModelSaver.SaveError> {
//        do { try manager.createDirectory(at: folder, withIntermediateDirectories: true) } catch let error {
//            return Fail(error: ModelSaver.SaveError.folderCouldNotBeCreated(error))
//                .eraseToAnyPublisher()
//        }
//
//        guard let data = model.data else {
//            return Fail(error: ModelSaver.SaveError.noDataProduced)
//                .eraseToAnyPublisher()
//        }
//
//        return Just((data, url(for: type(of: model))))
//            .tryMap { data, url in
//                try data.write(to: url)
//            }
//            .mapError { error in
//                ModelSaver.SaveError.other(error)
//            }
//            .eraseToAnyPublisher()
//    }
//
//    static func defaultLoadFunction(id: SavedModel.Type) -> AnyPublisher<Model, ModelSaver.LoadError> {
//        Just(url(for: id))
//            .tryMap { url in
//                try Data(contentsOf: url)
//            }
//            .mapError { ModelSaver.LoadError.fileNotRead($0) }
//            .tryMap { data in
//                try id.init(from: data)
//            }
//            .mapError { ModelSaver.LoadError.modelNotDecoded($0) }
//            .tryMap { savedModel in
//                guard let model = savedModel as? Model else {
//                    throw ModelSaver.LoadError.modelIsNotAModel
//                }
//
//                return model
//            }
//            .mapError { _ in ModelSaver.LoadError.modelIsNotAModel }
//            .eraseToAnyPublisher()
//    }
//
//    // MARK: - Default Implementation Helpers
//
//    private static func url(for modelType: SavedModel.Type) -> URL {
//        folder.appendingPathComponent(name(for: modelType))
//    }
//
//    private static func name(for modelType: SavedModel.Type) -> String {
//        String(describing: modelType) + ".json"
//    }
//
//    private static var folder: URL {
//        manager
//            .urls(for: .documentDirectory, in: .userDomainMask).first!
//            .appendingPathComponent("Substate")
//    }
//
//    private static var manager: FileManager { .default }
//}
