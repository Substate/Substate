import XCTest
import Substate
import SubstateMiddleware

@MainActor final class ActionDelayerTests: XCTestCase {

    struct Action1: Action {}

    struct Action2: Action, DelayedAction {
        let delay: TimeInterval = 1
    }

    struct Component: Model {
        var action1Received = false
        var action2Received = false

        mutating func update(action: Action) {
            switch action {
            case is Action1: action1Received = true
            case is Action2: action2Received = true
            default: ()
            }
        }
    }

    func testNonDelayedActionIsReceivedImmediately() async throws {
        let store = Store(model: Component(), middleware: [ActionDelayer()])
        try await store.dispatch(Action1())
        XCTAssertTrue(try XCTUnwrap(store.find(Component.self)).action1Received)
    }

    func testDelayedActionIsNotReceivedImmediately() async throws {
        let store = Store(model: Component(), middleware: [ActionDelayer()])
        try await store.dispatch(Action2())
        XCTAssertFalse(try XCTUnwrap(store.find(Component.self)).action2Received)
    }

    func testDelayedActionIsReceivedOnTime() async throws {
        let delayer = ActionDelayer()
        let publisher = ActionPublisher()
        let store = Store(model: Component(), middleware: [delayer, publisher])
        let expectation = XCTestExpectation()
        expectation.assertForOverFulfill = true
        let start = Date()

        publisher.callback(for: Action2.self) { action in
            let end = Date()
            let overshoot = end.timeIntervalSince(start) - action.delay
            XCTAssertLessThan(overshoot, 0.25)
            expectation.fulfill()
        }

        try await store.dispatch(Action2())
        wait(for: [expectation], timeout: 1.5)
    }

}
