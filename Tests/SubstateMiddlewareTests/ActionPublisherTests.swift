import XCTest
import Combine
import Substate
import SubstateMiddleware

@MainActor final class ActionPublisherTests: XCTestCase {

    struct Action1: Action {}

    struct Component: Model {
        mutating func update(action: Action) {}
    }

    var subscriptions: [AnyCancellable] = []

    func testActionIsPublishedUsingCombine() async throws {
        let publisher = ActionPublisher()
        let store = Store(model: Component(), middleware: [publisher])
        var actionWasPublished = false

        publisher.publisher(for: Action1.self)
            .sink { _ in actionWasPublished = true }
            .store(in: &subscriptions)

        XCTAssertFalse(actionWasPublished)
        try await store.dispatch(Action1())
        XCTAssertTrue(actionWasPublished)
    }

    func testActionIsPublishedUsingCallback() async throws {
        let publisher = ActionPublisher()
        let store = Store(model: Component(), middleware: [publisher])
        var actionWasPublished = false

        publisher.callback(for: Action1.self) { _ in
            actionWasPublished = true
        }

        XCTAssertFalse(actionWasPublished)
        try await store.dispatch(Action1())
        XCTAssertTrue(actionWasPublished)
    }

}
