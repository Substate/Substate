import Foundation
import Combine
import Substate

extension ModelSaver.Configuration {

    // MARK: - Default Implementations

    @Sendable static func defaultSaveFunction(model: SavedModel) async throws {
        do { try manager.createDirectory(at: folder, withIntermediateDirectories: true) } catch {
            throw ModelSaver.SaveError.folderCouldNotBeCreated(error)
        }

        guard let data = model.data else {
            throw ModelSaver.SaveError.noDataProduced
        }

        do { try data.write(to: url(for: type(of: model))) } catch {
            throw ModelSaver.SaveError.other(error)
        }
    }

    @Sendable static func defaultLoadFunction(type: SavedModel.Type) async throws -> Model {
        let data: Data
        let model: SavedModel

        do { data = try Data(contentsOf: url(for: type)) } catch {
            throw ModelSaver.LoadError.fileNotRead(error)
        }

        do { model = try type.init(from: data) } catch {
            throw ModelSaver.LoadError.modelNotDecoded(error)
        }

        guard let model = model as? Model else {
            throw ModelSaver.LoadError.modelIsNotAModel
        }

        return model
    }

    // MARK: - Default Implementation Helpers

    private static func url(for modelType: SavedModel.Type) -> URL {
        folder.appendingPathComponent(name(for: modelType))
    }

    private static func name(for modelType: SavedModel.Type) -> String {
        String(describing: modelType) + ".json"
    }

    private static var folder: URL {
        manager
            .urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("Substate")
    }

    private static var manager: FileManager { .default }
    
}
