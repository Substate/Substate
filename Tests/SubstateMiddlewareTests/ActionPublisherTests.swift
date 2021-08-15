import XCTest
import Combine
import Substate
import SubstateMiddleware

final class ActionPublisherTests: XCTestCase {

    struct Action1: Action {}

    struct Component: Model {
        mutating func update(action: Action) {}
    }

    var subscriptions: [AnyCancellable] = []

    func testActionIsPublishedUsingCombine() throws {
        let publisher = ActionPublisher()
        let store = Store(model: Component(), middleware: [publisher])
        var actionWasPublished = false

        publisher.publisher(for: Action1.self)
            .sink { _ in actionWasPublished = true }
            .store(in: &subscriptions)

        XCTAssertFalse(actionWasPublished)
        store.send(Action1())
        XCTAssertTrue(actionWasPublished)
    }

    func testActionIsPublishedUsingCallback() throws {
        let publisher = ActionPublisher()
        let store = Store(model: Component(), middleware: [publisher])
        var actionWasPublished = false

        publisher.callback(for: Action1.self) { _ in
            actionWasPublished = true
        }

        XCTAssertFalse(actionWasPublished)
        store.send(Action1())
        XCTAssertTrue(actionWasPublished)
    }

}
