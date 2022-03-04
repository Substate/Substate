import XCTest
import Substate

@MainActor final class StoreReplaceTests: XCTestCase {

    struct TestModel: Model {
        var value = 123
        var child = ChildModel()
    }

    struct ChildModel: Model {
        var value = 456
    }

    struct UnknownModel: Model {
        var value = 789
    }

    func testReplacedModelIsCorrectlyUpdated() async throws {
        let store = try await Store(model: TestModel())

        try await store.dispatch(Store.Replace(model: TestModel(value: 456)))
        XCTAssertEqual(store.find(TestModel.self)?.value, 456)
    }

    func testReplacementFailsWithUnknownModel() async throws {
        let store = try await Store(model: TestModel())

        try await store.dispatch(Store.Replace(model: UnknownModel()))
        XCTAssertNil(store.find(UnknownModel.self))

        // Check failed replacement didn’t break main model
        XCTAssertEqual(store.find(TestModel.self)?.value, 123)
    }

    func testNestedReplacementsDontInterfere() async throws {
        let store = try await Store(model: TestModel())

        try await store.dispatch(Store.Replace(model: TestModel(value: 321)))
        XCTAssertEqual(store.find(TestModel.self)?.value, 321)

        // Double-check child model state was not changed
        XCTAssertEqual(store.find(ChildModel.self)?.value, 456)

        try await store.dispatch(Store.Replace(model: ChildModel(value: 654)))
        XCTAssertEqual(store.find(ChildModel.self)?.value, 654)

        // Double-check outer model state was not changed
        XCTAssertEqual(store.find(TestModel.self)?.value, 321)
    }

}
