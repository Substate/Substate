import XCTest
import Combine

@testable import Substate
@testable import SubstateMiddleware

@MainActor final class ActionStreamModelTests: XCTestCase {

    struct TestAction: Action {
        var value = 1
    }

    struct TestModel: Model, Equatable {
        var value = 1

        mutating func update(action: Action) {
            if action is TestAction { value += 1 }
        }
    }

    // MARK: - Models

    func testModelSubscription() async throws {
        var value = 1

        let stream = ActionStream { stream in
            TestModel
                .subscribe(on: stream)
                .sink { value = $0.value }
        }

        let store = try await Store(model: TestModel(), middleware: [stream])

        try await store.dispatch(TestAction())
        XCTAssertEqual(value, 2)
    }

    // MARK: - Values

    func testModelValueSubscription() async throws {
        var value = 1

        let stream = ActionStream { stream in
            (\TestModel.value)
                .subscribe(on: stream)
                .sink { value = $0 }
        }

        let store = try await Store(model: TestModel(), middleware: [stream])

        try await store.dispatch(TestAction())
        XCTAssertEqual(value, 2)
    }

}
