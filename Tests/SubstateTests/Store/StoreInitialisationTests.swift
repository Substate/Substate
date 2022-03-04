import XCTest
import Substate
import SubstateMiddleware

@MainActor final class StoreInitialisationTests: XCTestCase {

    struct TestModel: Model {
        var value = 123
        var child = ChildModel()
    }

    struct ChildModel: Model {
        var value = 456
    }

    func testInitialisationSucceeds() async throws {
        _ = try await Store(model: TestModel())
    }

    func testModelValueIsCorrectAfterInitialisation() async throws {
        let store = try await Store(model: TestModel())

        XCTAssertEqual(store.find(TestModel.self)?.value, 123)
    }

    func testChildModelValueIsCorrectAfterInitialisation() async throws {
        let store = try await Store(model: TestModel())

        XCTAssertEqual(store.find(ChildModel.self)?.value, 456)
    }

    func testStartActionIsDispatchedDuringInitialisation() async throws {
        let catcher = ActionCatcher()
        _ = try await Store(model: TestModel(), middleware: [catcher])

        XCTAssertEqual(catcher.find(Store.Start.self).count, 1)
    }

}
