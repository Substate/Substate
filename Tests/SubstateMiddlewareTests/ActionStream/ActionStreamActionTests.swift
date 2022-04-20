import XCTest
import Combine

@testable import Substate
@testable import SubstateMiddleware

@MainActor final class ActionStreamActionTests: XCTestCase {

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
            TestAction
                .subscribe(on: stream)
                .sink { count += 1 }
        }

        let store = try await Store(model: TestModel(), middleware: [stream])

        try await store.dispatch(TestAction())
        XCTAssertEqual(count, 1)
    }

    // MARK: - Actions + Model Values

    func testActionAnd1ModelValueSubscription() async throws {
        var count = 0
        var value1 = 1

        let stream = ActionStream { stream in
            TestAction
                .subscribe(on: stream, with: \TestModel.value)
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
            TestAction
                .subscribe(on: stream, with: \TestModel.value, \TestModel.value)
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
            TestAction
                .subscribe(on: stream, with: \TestModel.value, \TestModel.value, \TestModel.value)
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
