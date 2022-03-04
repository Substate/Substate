import XCTest
import Substate

@MainActor final class StoreMiddlewareTests: XCTestCase {

    struct TestAction: Action {}

    struct TestModel: Model {
        var value = 123
    }

    class TestMiddleware: Middleware {
        var modelValue: Int? = nil
        var startActionSeen = false
        var testActionSeen = false

        func configure(store: Store) -> (@escaping DispatchFunction) -> DispatchFunction {
            { next in
                { action in
                    if action is Store.Start {
                        self.startActionSeen = true
                    }

                    if action is TestAction {
                        self.testActionSeen = true
                    }

                    self.modelValue = store.find(TestModel.self)?.value
                    try await next(action)
                }
            }
        }
    }

    func testMiddlewareReceivesStartAction() async throws {
        let middleware = TestMiddleware()
        _ = try await Store(model: TestModel(), middleware: [middleware])

        XCTAssertTrue(middleware.startActionSeen)
    }

    func testMiddlewareReceivesDispatchedAction() async throws {
        let middleware = TestMiddleware()
        let store = try await Store(model: TestModel(), middleware: [middleware])

        try await store.dispatch(TestAction())
        XCTAssertTrue(middleware.testActionSeen)
    }

    func testMiddlewareCanGetModelValue() async throws {
        let middleware = TestMiddleware()
        _ = try await Store(model: TestModel(), middleware: [middleware])

        XCTAssertEqual(middleware.modelValue, 123)
    }

}
