/// TODO: Tidy these names up
///
extension ModelSaver {

    public enum LoadError: Error {
        case fileNotRead
    }

    public enum SaveError: Error {
        case modelNotFound
        case modelIsNotASavedModel
        case noDataProduced
        case folderCouldNotBeCreated(Error)
        case unknown(Error)
    }

}
