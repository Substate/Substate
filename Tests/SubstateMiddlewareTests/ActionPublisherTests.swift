import XCTest
import Combine
import Substate
import SubstateMiddleware

final class ActionPublisherTests: XCTestCase {

    struct Action1: Action {}

    struct Component: State {
        mutating func update(action: Action) {}
    }

    var subscriptions: [AnyCancellable] = []

    func testActionIsPublishedUsingCombine() throws {
        let publisher = ActionPublisher()
        let store = Store(state: Component(), middleware: [publisher])
        var actionWasPublished = false

        publisher.publisher(for: Action1.self)
            .sink { _ in actionWasPublished = true }
            .store(in: &subscriptions)

        XCTAssertFalse(actionWasPublished)
        store.update(Action1())
        XCTAssertTrue(actionWasPublished)
    }

    func testActionIsPublishedUsingCallback() throws {
        let publisher = ActionPublisher()
        let store = Store(state: Component(), middleware: [publisher])
        var actionWasPublished = false

        publisher.callback(for: Action1.self) { _ in
            actionWasPublished = true
        }

        XCTAssertFalse(actionWasPublished)
        store.update(Action1())
        XCTAssertTrue(actionWasPublished)
    }

}
