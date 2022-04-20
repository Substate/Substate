import XCTest
import Combine

@testable import Substate
@testable import SubstateMiddleware

@MainActor final class ActionStreamTimingTests: XCTestCase {

    struct TestModel: Model {}
    struct TestAction1: Action {}
    struct TestAction2: Action {}

    func testActionDebounce() async throws {
        let stream = ActionStream { stream in
            stream.publisher(for: TestAction1.self)
                .debounce(for: 0.1, scheduler: RunLoop.main)
                .map { _ in TestAction2() }
                .eraseToAnyPublisher()
        }

        let catcher = ActionCatcher()
        let store = try await Store(model: TestModel(), middleware: [stream, catcher])

        try await store.dispatch(TestAction1())
        try await store.dispatch(TestAction1())
        try await store.dispatch(TestAction1())
        try await store.dispatch(TestAction1())
        try await store.dispatch(TestAction1())
        XCTAssertEqual(catcher.count(for: TestAction2.self), 0) // t = 0

        try await Task.sleep(nanoseconds: 75_000_000) // t = 0.075s
        XCTAssertEqual(catcher.count(for: TestAction2.self), 0)

        try await Task.sleep(nanoseconds: 150_000_000) // t = 0.125s
        XCTAssertEqual(catcher.count(for: TestAction2.self), 1)
    }

    func testActionDelay() async throws {
        let stream = ActionStream { stream in
            stream.publisher(for: TestAction1.self)
                .delay(for: 0.1, scheduler: RunLoop.main)
                .map { _ in TestAction2() }
                .eraseToAnyPublisher()
        }

        let catcher = ActionCatcher()
        let store = try await Store(model: TestModel(), middleware: [stream, catcher])

        try await store.dispatch(TestAction1())
        XCTAssertEqual(catcher.count(for: TestAction2.self), 0) // t = 0

        try await Task.sleep(nanoseconds: 75_000_000) // t = 0.075s
        XCTAssertEqual(catcher.count(for: TestAction2.self), 0)

        try await Task.sleep(nanoseconds: 50_000_000) // t = 0.125s
        XCTAssertEqual(catcher.count(for: TestAction2.self), 1)
    }

}
