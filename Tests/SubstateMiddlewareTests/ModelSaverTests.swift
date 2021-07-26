import XCTest
import Combine
import Substate
import SubstateMiddleware

final class ModelSaverTests: XCTestCase {

    // MARK: - Sample Data

    struct Model1: Model, SavedModel, Codable {
        var value = 123
        mutating func update(action: Action) {}
    }

    struct Counter: Model, SavedModel, Codable {
        var value = 123
        var tracker = Tracker<Counter>()
        mutating func update(action: Action) {}
    }

    struct Tracker<Parent>: Model, SavedModel, Codable {
        var count = 456
        mutating func update(action: Action) {}
    }

    // MARK: - Loading

//    func testLoadAllModels() throws {
//
//    }

    // MARK: - Saving

    // Lots to tidy up here, but working!
    func testSuccessfulModelSave() throws {
        let saveCallbackExpectation = XCTestExpectation()
        var configuration = ModelSaver.Configuration()

        configuration.save = { model in
            guard let model = model as? Model1 else {
                XCTFail()
                return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            XCTAssertEqual(model.value, 123)
            saveCallbackExpectation.fulfill()
            return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        let saver = ModelSaver(configuration: configuration)
        let logger = ActionLogger()
        let store = Store(model: Model1(), middleware: [logger, saver])

        store.update(ModelSaver.Save(Model1.self))

        // TODO: Check SaveDidSucceed is called
        // TODO: Some middleware to help us test more easily
        // eg. TestMiddleware().expectation(for: ModelSaver.SaveDidSucceed.self)
        // eg. TestMiddleware().expectation(for: ModelSaver.SaveDidSucceed(value: 123))

        wait(for: [saveCallbackExpectation], timeout: 1)
    }

//    func testFailingModelSave() throws {
//        // ...
//    }

}
