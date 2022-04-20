import XCTest
import Combine

@testable import Substate
@testable import SubstateMiddleware

@MainActor final class ActionStreamDispatchTests: XCTestCase {

    struct TestModel: Model {}
    struct TestAction1: Action {}
    struct TestAction2: Action {}

    func testDispatchActionFromPublisher() async throws {
        let publisher = PassthroughSubject<Int, Never>()

        let stream = ActionStream { stream in
            publisher
                .map { _ in TestAction2() }
                .eraseToAnyPublisher()
        }

        let catcher = ActionCatcher()
        let _ = try await Store(model: TestModel(), middleware: [stream, catcher])

        publisher.send(1)
        try await Task.sleep(nanoseconds: 1_000_000)
        // TODO: Better test completion mechanism than waiting for 1ms.
        XCTAssertEqual(catcher.count(for: TestAction2.self), 1)
    }

    func testDispatchActionFromAnotherAction() async throws {
        let stream = ActionStream { stream in
            TestAction1
                .subscribe(on: stream)
                .map { TestAction2() }
                .eraseToAnyPublisher()
        }

        let catcher = ActionCatcher()
        let store = try await Store(model: TestModel(), middleware: [stream, catcher])

        try await store.dispatch(TestAction1())
        try await Task.sleep(nanoseconds: 1_000_000)
        // TODO: Better test completion mechanism than waiting for 1ms.
        XCTAssertEqual(catcher.count(for: TestAction2.self), 1)
    }

}
