import XCTest
import Combine
import Substate
import SubstateMiddleware

final class ModelSaverTests: XCTestCase {

    // MARK: - Sample Data

    struct Model1: Model, SavedModel, Equatable {
        var value = 123
        var model2 = Model2()
        mutating func update(action: Action) {
            if let a = action as? ModelSaver.LoadDidSucceed, let model = a.model as? Self {
                self = model
            }
        }
    }

    struct Model2: Model, Codable, Equatable {
        var value = 456
        mutating func update(action: Action) {}
    }

    struct Counter: Model, SavedModel {
        var value = 123
        var tracker = Tracker<Counter>()
        mutating func update(action: Action) {}
    }

    struct Tracker<Parent>: Model, SavedModel {
        var count = 456
        mutating func update(action: Action) {}
    }

    // MARK: - Loading

//    func testLoadAllModels() throws {
//
//    }

    // MARK: - Saving

    // TODO: Check SaveDidSucceed is called
    // TODO: Some middleware to help us test more easily
    // eg. TestMiddleware().expectation(for: ModelSaver.SaveDidSucceed.self)
    // eg. TestMiddleware().expectation(for: ModelSaver.SaveDidSucceed(value: 123))
    // eg. TestMiddleware().expectation(notSeen: ModelSaver.SaveDidFail.self)

    // Lots to tidy up here, but working!
    func testSuccessfulModelSave() throws {
        let saveFunctionExpectation = XCTestExpectation()

        let save: ModelSaver.Configuration.SaveFunction = { model in
            guard let model = model as? Model1 else {
                XCTFail("Model provided to save function was not of the expected type")
                return Just(()).setFailureType(to: ModelSaver.SaveError.self).eraseToAnyPublisher()
            }
            XCTAssertEqual(model.value, 123)
            saveFunctionExpectation.fulfill()
            return Just(()).setFailureType(to: ModelSaver.SaveError.self).eraseToAnyPublisher()
        }

        let saver = ModelSaver(configuration: .init(save: save, saveStrategy: .manual))
        let logger = ActionLogger()
        let store = Store(model: Model1(), middleware: [logger, saver])

        store.send(ModelSaver.Save(Model1.self))
        // TODO: Test SaveDidSucceed is received

        wait(for: [saveFunctionExpectation], timeout: 1)
    }

    func testSuccessfulModelLoad() throws {
        let loadFunctionExpectation = XCTestExpectation()

        let load: ModelSaver.Configuration.LoadFunction = { id in
            XCTAssert(id is Model1.Type)
            loadFunctionExpectation.fulfill()
            return Just(Model1()).setFailureType(to: ModelSaver.LoadError.self).eraseToAnyPublisher()
        }

        let saver = ModelSaver(configuration: .init(load: load, loadStrategy: .manual))
        let logger = ActionLogger()
        let store = Store(model: Model1(), middleware: [logger, saver])

        store.send(ModelSaver.Load(Model1.self))
        // TODO: Test LoadDidSucceed is received

        wait(for: [loadFunctionExpectation], timeout: 1)
    }

    func testFilesystemRoundtrip() throws {
        let model1 = Model1(value: .random(in: 1...100))
        let model2 = Model1(value: .random(in: 1...100))

        let saver1 = ModelSaver()
        let actionLogger1 = ActionLogger()
        let store1 = Store(model: model1, middleware: [actionLogger1, saver1])
        store1.send(ModelSaver.Save(Model1.self))

        let saver2 = ModelSaver()
        let actionLogger2 = ActionLogger()
        let store2 = Store(model: model2, middleware: [actionLogger2, saver2])
        store2.send(ModelSaver.Load(Model1.self))

        let expectation = XCTestExpectation()

        DispatchQueue.main.async {
            // Just wait until next tick so that save/load calls
            // have run and store2’s mode has been updated.
            expectation.fulfill()
            XCTAssertEqual(store2.find(Model1.self)?.value, model1.value)
        }

        wait(for: [expectation], timeout: 1)
    }

}
