/// TODO: Tidy these names up
///
extension ModelSaver {

    public enum LoadError: Error {
        case missingConfiguration
        case fileNotRead(Error)
        case modelNotDecoded(Error)
        case modelIsNotAModel
        case modelIsNotASavedModel
        case wrongModelTypeReturned
        case other(Error)
    }

    public enum SaveError: Error {
        case saveNotNeeded
        case missingConfiguration
        case modelNotFound
        case modelIsNotASavedModel
        case noDataProduced
        case folderCouldNotBeCreated(Error)
        case other(Error)
    }

}
