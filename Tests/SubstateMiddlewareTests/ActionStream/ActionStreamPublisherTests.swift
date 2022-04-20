import XCTest
import Combine

@testable import Substate
@testable import SubstateMiddleware

@MainActor final class ActionStreamPublisherTests: XCTestCase {

    struct TestAction: Action {
        var value = 1
    }

    struct TestModel: Model, Equatable {
        var value = 1

        mutating func update(action: Action) {
            if action is TestAction { value += 1 }
        }
    }

    // MARK: - Actions

    func testActionSubscription() async throws {
        var count = 0

        let stream = ActionStream { stream in
            stream.publisher(for: TestAction.self)
                .sink { _ in count += 1 }
        }

        let store = try await Store(model: TestModel(), middleware: [stream])

        try await store.dispatch(TestAction())
        XCTAssertEqual(count, 1)
    }

    // MARK: - Values

    func testModelSubscription() async throws {
        var value = 1

        let stream = ActionStream { stream in
            stream.publisher(for: \TestModel.self)
                .sink { value = $0.value }
        }

        let store = try await Store(model: TestModel(), middleware: [stream])

        try await store.dispatch(TestAction())
        XCTAssertEqual(value, 2)
    }

    func testModelValueSubscription() async throws {
        var value = 1

        let stream = ActionStream { stream in
            stream.publisher(for: \TestModel.value)
                .sink { value = $0 }
        }

        let store = try await Store(model: TestModel(), middleware: [stream])

        try await store.dispatch(TestAction())
        XCTAssertEqual(value, 2)
    }

    // MARK: - Actions + Values

    func testActionAnd1ModelValueSubscription() async throws {
        var count = 0
        var value1 = 1

        let stream = ActionStream { stream in
            stream.publisher(for: TestAction.self, with: \TestModel.value)
                .sink { action, modelValue1 in
                    count += 1
                    value1 = modelValue1
                }
        }

        let store = try await Store(model: TestModel(), middleware: [stream])

        try await store.dispatch(TestAction())
        XCTAssertEqual(value1, 2)
    }

    func testActionAnd2ModelValuesSubscription() async throws {
        var count = 0
        var value1 = 1
        var value2 = 1

        let stream = ActionStream { stream in
            stream.publisher(for: TestAction.self, with: \TestModel.value, \TestModel.value)
                .sink { action, modelValue1, modelValue2 in
                    count += 1
                    value1 = modelValue1
                    value2 = modelValue2
                }
        }

        let store = try await Store(model: TestModel(), middleware: [stream])

        try await store.dispatch(TestAction())
        XCTAssertEqual(value1, 2)
        XCTAssertEqual(value2, 2)
    }

    func testActionAnd3ModelValuesSubscription() async throws {
        var count = 0
        var value1 = 1
        var value2 = 1
        var value3 = 1

        let stream = ActionStream { stream in
            stream.publisher(for: TestAction.self, with: \TestModel.value, \TestModel.value, \TestModel.value)
                .sink { action, modelValue1, modelValue2, modelValue3 in
                    count += 1
                    value1 = modelValue1
                    value2 = modelValue2
                    value3 = modelValue3
                }
        }

        let store = try await Store(model: TestModel(), middleware: [stream])

        try await store.dispatch(TestAction())
        XCTAssertEqual(value1, 2)
        XCTAssertEqual(value2, 2)
        XCTAssertEqual(value3, 2)
    }

}
