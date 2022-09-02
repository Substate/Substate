import XCTest
import Combine

@testable import Substate
@testable import SubstateMiddleware

@MainActor final class ActionStreamDependencyTests: XCTestCase {

    struct TestModel: Model {}
    struct TestAction1: Action {}
    struct TestAction2: Action {}

    struct TestActionSuccess: Action {}
    struct TestActionFailure: Action {}

    enum TestError: Error { case test }

    func testClassDependency() async throws {
        class Dependency {
            @Published var value = 1
        }

        var value = 0

        let stream = ActionStream { stream in
            let dependency = Dependency()

            TestAction1
                .subscribe(on: stream)
                .sink { _ in dependency.value += 1 }

            dependency.$value
                .sink { value = $0 }
        }

        let catcher = ActionCatcher()
        let store = try await Store(model: TestModel(), middleware: [stream, catcher])

        try await store.dispatch(TestAction1())
        XCTAssertEqual(value, 2)
    }

    func testThrowingDependency() async throws {
        func dependency(shouldThrow: Bool) throws {
            if shouldThrow { throw TestError.test }
        }

        let stream = ActionStream { stream in
            stream.publisher(for: TestAction1.self)
                .tryMap { _ in try dependency(shouldThrow: false) }
                .map(TestActionSuccess.init)
                .replaceError(with: TestActionFailure())

            stream.publisher(for: TestAction2.self)
                .tryMap { _ in try dependency(shouldThrow: true) }
                .map(TestActionSuccess.init)
                .replaceError(with: TestActionFailure())
        }

        let catcher1 = ActionCatcher()
        let store1 = try await Store(model: TestModel(), middleware: [stream, catcher1])

        try await store1.dispatch(TestAction1())
        try await Task.sleep(nanoseconds: 1_000_000)
        // TODO: Better test completion mechanism than waiting for 1ms.
        XCTAssertEqual(catcher1.count(for: TestActionSuccess.self), 1)

        let catcher2 = ActionCatcher()
        let store2 = try await Store(model: TestModel(), middleware: [stream, catcher2])

        try await store2.dispatch(TestAction2())
        try await Task.sleep(nanoseconds: 1_000_000)
        // TODO: Better test completion mechanism than waiting for 1ms.
        XCTAssertEqual(catcher2.count(for: TestActionFailure.self), 1)
    }

}
