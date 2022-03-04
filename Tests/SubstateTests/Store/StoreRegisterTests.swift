import XCTest
import Substate

@MainActor final class StoreRegisterTests: XCTestCase {

    struct TestAction: Action {}

    struct TestModel: Model {
        var value = 123
    }

    struct DynamicModel: Model, Equatable {
        var value = 456

        mutating func update(action: Action) {
            if action is TestAction {
                value = 789
            }
        }
    }

    func testRegisteredModelIsPresent() async throws {
        let store = try await Store(model: TestModel())

        try await store.dispatch(Store.Register(model: DynamicModel()))
        XCTAssertNotNil(store.find(DynamicModel.self))
    }

    func testRegisteredModelIsCorrectlyUpdated() async throws {
        let store = try await Store(model: TestModel())

        try await store.dispatch(Store.Register(model: DynamicModel()))
        XCTAssertEqual(store.find(DynamicModel.self)?.value, 456)

        try await store.dispatch(TestAction())
        XCTAssertEqual(store.find(DynamicModel.self)?.value, 789)
    }

}
