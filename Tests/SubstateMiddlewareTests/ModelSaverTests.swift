import XCTest
import Substate
import SubstateMiddleware

@MainActor final class ModelSaverTests: XCTestCase {

    struct TestModel: Model, SavedModel {
        var value = 100
    }

    struct UnexpectedModel: Model, SavedModel {
        var value = 200
    }

    struct ParentModel: Model {
        var child1 = ChildModel1()
        var child2 = ChildModel2()
    }

    struct ChildModel1: Model, SavedModel {
        var value = 300
    }

    struct ChildModel2: Model, SavedModel {
        var value = 400
    }

    // MARK: - Configuration

    func testConfigurationIsRegisteredOnStoreStart() async throws {
        let saver = ModelSaver()
        let store = try await Store(model: TestModel(), middleware: [saver])

        XCTAssertNotNil(store.find(ModelSaver.Configuration.self))
    }

    // MARK: - Loading

    func testManualLoad() async throws {
        let load: ModelSaver.Configuration.LoadFunction = { type in
            return TestModel(value: 101)
        }

        let catcher = ActionCatcher()
        let saver = ModelSaver(configuration: .init(load: load, loadStrategy: .manual))
        let store = try await Store(model: TestModel(), middleware: [catcher, saver])

        try await store.dispatch(ModelSaver.Load(TestModel.self))
        XCTAssertEqual(catcher.count(for: ModelSaver.LoadDidSucceed.self), 1)
        XCTAssertEqual(catcher.count(for: ModelSaver.LoadDidComplete.self), 1)
        XCTAssertEqual(catcher.count(for: ModelSaver.LoadDidFail.self), 0)
        XCTAssertEqual(store.find(TestModel.self)?.value, 101)
    }

    func testFailingManualLoad() async throws {
        let load: ModelSaver.Configuration.LoadFunction = { type in
            return UnexpectedModel()
        }

        let catcher = ActionCatcher()

        let saver = ModelSaver(configuration: .init(load: load, loadStrategy: .manual))
        let store = try await Store(model: TestModel(), middleware: [catcher, saver])

        try await store.dispatch(ModelSaver.Load(TestModel.self))
        XCTAssertEqual(catcher.count(for: ModelSaver.LoadDidFail.self), 1)
        XCTAssertEqual(catcher.count(for: ModelSaver.LoadDidComplete.self), 1)
        XCTAssertEqual(catcher.count(for: ModelSaver.LoadDidSucceed.self), 0)
    }

    func testManualLoadAll() async throws {
        let load: ModelSaver.Configuration.LoadFunction = { type in
            switch type {
            case is ChildModel1.Type: return ChildModel1(value: 101)
            case is ChildModel2.Type: return ChildModel2(value: 202)
            default: XCTFail("Unexpected model type load requested"); fatalError()
            }
        }

        let catcher = ActionCatcher()
        let saver = ModelSaver(configuration: .init(load: load, loadStrategy: .manual))
        let store = try await Store(model: ParentModel(), middleware: [catcher, saver])

        try await store.dispatch(ModelSaver.LoadAll())
        XCTAssertEqual(catcher.count(for: ModelSaver.LoadDidSucceed.self), 2)
        XCTAssertEqual(catcher.count(for: ModelSaver.LoadDidComplete.self), 2)
        XCTAssertEqual(catcher.count(for: ModelSaver.LoadAllDidComplete.self), 1)
        XCTAssertEqual(catcher.count(for: ModelSaver.LoadDidFail.self), 0)
        XCTAssertEqual(store.find(ChildModel1.self)?.value, 101)
        XCTAssertEqual(store.find(ChildModel2.self)?.value, 202)
    }

    func testAutomaticLoadAll() async throws {
        let load: ModelSaver.Configuration.LoadFunction = { type in
            switch type {
            case is ChildModel1.Type: return ChildModel1(value: 101)
            case is ChildModel2.Type: return ChildModel2(value: 202)
            default: XCTFail("Unexpected model type load requested"); fatalError()
            }
        }

        let catcher = ActionCatcher()
        let saver = ModelSaver(configuration: .init(load: load, loadStrategy: .automatic))
        let store = try await Store(model: ParentModel(), middleware: [catcher, saver])

        XCTAssertEqual(catcher.count(for: ModelSaver.LoadDidSucceed.self), 2)
        XCTAssertEqual(catcher.count(for: ModelSaver.LoadDidComplete.self), 2)
        XCTAssertEqual(catcher.count(for: ModelSaver.LoadAllDidComplete.self), 1)
        XCTAssertEqual(catcher.count(for: ModelSaver.LoadDidFail.self), 0)
        XCTAssertEqual(store.find(ChildModel1.self)?.value, 101)
        XCTAssertEqual(store.find(ChildModel2.self)?.value, 202)
    }

    // MARK: - Saving

    func testManualSave() async throws {
        let expectation = expectation(description: "Save function called")

        let save: ModelSaver.Configuration.SaveFunction = { model in
            XCTAssertTrue(model is TestModel)
            expectation.fulfill()
        }

        let catcher = ActionCatcher()
        let saver = ModelSaver(configuration: .init(save: save, loadStrategy: .manual, saveStrategy: .manual))
        let store = try await Store(model: TestModel(), middleware: [catcher, saver])

        try await store.dispatch(ModelSaver.Save(TestModel.self))
        XCTAssertEqual(catcher.count(for: ModelSaver.SaveDidSucceed.self), 1)
        XCTAssertEqual(catcher.count(for: ModelSaver.SaveDidComplete.self), 1)
        XCTAssertEqual(catcher.count(for: ModelSaver.SaveDidFail.self), 0)
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFailingManualSave() async throws {
        let save: ModelSaver.Configuration.SaveFunction = { model in
            throw ModelSaver.SaveError.noDataProduced
        }

        let catcher = ActionCatcher()
        let saver = ModelSaver(configuration: .init(save: save, loadStrategy: .manual, saveStrategy: .manual))
        let store = try await Store(model: TestModel(), middleware: [catcher, saver])

        try await store.dispatch(ModelSaver.Save(TestModel.self))
        XCTAssertEqual(catcher.count(for: ModelSaver.SaveDidFail.self), 1)
        XCTAssertEqual(catcher.count(for: ModelSaver.SaveDidComplete.self), 1)
        XCTAssertEqual(catcher.count(for: ModelSaver.SaveDidSucceed.self), 0)
    }

    func testManualSaveAll() async throws {
        let expectation1 = expectation(description: "Save function called for Child 1")
        let expectation2 = expectation(description: "Save function called for Child 2")

        let save: ModelSaver.Configuration.SaveFunction = { model in
            if model is ChildModel1 { expectation1.fulfill() }
            if model is ChildModel2 { expectation2.fulfill() }
        }

        let catcher = ActionCatcher()
        let saver = ModelSaver(configuration: .init(save: save, loadStrategy: .manual, saveStrategy: .manual))
        let store = try await Store(model: ParentModel(), middleware: [catcher, saver])

        try await store.dispatch(ModelSaver.SaveAll())
        XCTAssertEqual(catcher.count(for: ModelSaver.SaveDidSucceed.self), 2)
        XCTAssertEqual(catcher.count(for: ModelSaver.SaveDidComplete.self), 2)
        XCTAssertEqual(catcher.count(for: ModelSaver.SaveAllDidComplete.self), 1)
        XCTAssertEqual(catcher.count(for: ModelSaver.SaveDidFail.self), 0)
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testMultipleThrashingSaves() async throws {
        // Saves multiple times including a previously-saved value, to make sure the save de-dupe
        // cache isn’t misbehaving and missing saves that look the same as some previous save state.

        let model = TestModel(value: .random(in: 1...100))
        var savedModel: TestModel? = nil

        let load: ModelSaver.Configuration.LoadFunction = { type in
            return try XCTUnwrap(savedModel)
        }

        let save: ModelSaver.Configuration.SaveFunction = { model in
            savedModel = (model as! TestModel)
        }

        let saver1 = ModelSaver(configuration: .init(load: load, save: save, loadStrategy: .manual, saveStrategy: .manual))
        let store1 = try await Store(model: model, middleware: [saver1])

        let saver2 = ModelSaver(configuration: .init(load: load, save: save, loadStrategy: .manual, saveStrategy: .manual))
        let store2 = try await Store(model: model, middleware: [saver2])

        try await store1.dispatch(Store.Replace(model: TestModel(value: model.value + 1)))
        try await store1.dispatch(ModelSaver.Save(TestModel.self))

        try await store1.dispatch(Store.Replace(model: TestModel(value: model.value - 1)))
        try await store1.dispatch(ModelSaver.Save(TestModel.self))

        try await store1.dispatch(Store.Replace(model: TestModel(value: model.value + 1)))
        try await store1.dispatch(ModelSaver.Save(TestModel.self))

        try await store2.dispatch(ModelSaver.Load(TestModel.self))
        XCTAssertEqual(store2.find(TestModel.self)?.value, model.value + 1)
    }

    // MARK: - Integration

    func testSaveAndLoadRoundtrip() async throws {
        let model1 = TestModel(value: .random(in: Int.min...0))
        let model2 = TestModel(value: .random(in: 1...Int.max))

        let saver1 = ModelSaver(configuration: .init(loadStrategy: .manual, saveStrategy: .manual))
        let store1 = try await Store(model: model1, middleware: [saver1])

        let saver2 = ModelSaver(configuration: .init(loadStrategy: .manual, saveStrategy: .manual))
        let store2 = try await Store(model: model2, middleware: [saver2])

        try await store1.dispatch(ModelSaver.Save(TestModel.self))
        try await store2.dispatch(ModelSaver.Load(TestModel.self))
        XCTAssertEqual(store2.find(TestModel.self)?.value, model1.value)
    }

    // MARK: - Save De-Duplication

    func testModelsAreOnlySavedWhenModified() async throws {
        let model = TestModel(value: .random(in: Int.min...Int.max))
        var modelSaveCount = 0

        let save: ModelSaver.Configuration.SaveFunction = { model in
            modelSaveCount += 1
        }

        let saver = ModelSaver(configuration: .init(save: save, loadStrategy: .manual, saveStrategy: .manual))
        let store = try await Store(model: model, middleware: [saver])
        XCTAssertEqual(modelSaveCount, 0)

        try await store.dispatch(ModelSaver.Save(TestModel.self))
        XCTAssertEqual(modelSaveCount, 1)

        try await store.dispatch(ModelSaver.Save(TestModel.self))
        try await store.dispatch(ModelSaver.Save(TestModel.self))
        try await store.dispatch(ModelSaver.Save(TestModel.self))
        XCTAssertEqual(modelSaveCount, 1)

        try await store.dispatch(Store.Replace(model: TestModel(value: 101)))
        try await store.dispatch(ModelSaver.Save(TestModel.self))
        XCTAssertEqual(modelSaveCount, 2)
    }

}
