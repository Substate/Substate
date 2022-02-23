import XCTest
import Combine

import Substate
import SubstateMiddleware

final class ActionTrackerAsyncTests: XCTestCase {

    struct Action1: Action, Equatable {}
    struct Action2: Action, Equatable, TrackedAction {}

    struct MyActions {
        struct Action3: Action, Equatable, TrackedAction {}
    }

    struct Action4: Action, TrackedAction {
        let trackingName = "action-4-custom-id"
        let trackingMetadata: [String:Any] = ["foo":123, "bar":"baz"]
    }

    struct Model1: Model {
        let value = 123
        mutating func update(action: Action) {}
    }

    // MARK: - Basic Output

    func testTrackerProducesOutputForTrackedAction() throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: Model1(), middleware: [tracker, catcher])

        store.send(Action2())

        XCTAssertTrue(catcher.actions.contains(where: { $0 is ActionTracker.Event }))
    }

    func testTrackerProducesNoOutputForUntrackedAction() throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: Model1(), middleware: [tracker, catcher])

        store.send(Action1())

        XCTAssertFalse(catcher.actions.contains(where: { $0 is ActionTracker.Event }))
    }

    // MARK: - Tracking Name

    func testTrackerProducesCorrectDefaultActionName() throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: Model1(), middleware: [tracker, catcher])

        store.send(Action2())

        let event = try XCTUnwrap(catcher.actions.compactMap({ $0 as? ActionTracker.Event }).first)

        XCTAssertEqual(event.action.trackingName, "SubstateMiddlewareTests.ActionTrackerAsyncTests.Action2")
    }

    func testTrackerProducesCorrectDefaultNestedActionName() throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: Model1(), middleware: [tracker, catcher])

        store.send(MyActions.Action3())

        let event = try XCTUnwrap(catcher.actions.compactMap({ $0 as? ActionTracker.Event }).first)

        XCTAssertEqual(event.action.trackingName, "SubstateMiddlewareTests.ActionTrackerAsyncTests.MyActions.Action3")
    }

    func testTrackerProducesCorrectCustomActionName() throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: Model1(), middleware: [tracker, catcher])

        store.send(Action4())

        let event = try XCTUnwrap(catcher.actions.compactMap({ $0 as? ActionTracker.Event }).first)

        XCTAssertEqual(event.action.trackingName, "action-4-custom-id")
    }

    // MARK: - Tracking Metadata

    func testTrackerProducesCorrectDefaultActionMetadata() throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: Model1(), middleware: [tracker, catcher])

        store.send(Action2())

        let event = try XCTUnwrap(catcher.actions.compactMap({ $0 as? ActionTracker.Event }).first)

        let metadataKeys = Array(event.action.trackingMetadata.keys)
        let metadataActionValue = try XCTUnwrap(event.action.trackingMetadata["action"] as? String)

        XCTAssertEqual(metadataKeys, ["action"])
        XCTAssertEqual(metadataActionValue, "SubstateMiddlewareTests.ActionTrackerAsyncTests.Action2")
    }

    func testTrackerProducesCorrectCustomActionMetadata() throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: Model1(), middleware: [tracker, catcher])

        store.send(Action4())

        let event = try XCTUnwrap(catcher.actions.compactMap({ $0 as? ActionTracker.Event }).first)

        let metadataFooValue = try XCTUnwrap(event.action.trackingMetadata["foo"] as? Int)
        let metadataBarValue = try XCTUnwrap(event.action.trackingMetadata["bar"] as? String)

        XCTAssertEqual(metadataFooValue, 123)
        XCTAssertEqual(metadataBarValue, "baz")
    }

}
