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
        mutating func update(action: Action) {}
    }

    // MARK: - Basic Output

    func testTrackerProducesOutputForTrackedAction() throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: Model1(), middleware: [tracker, catcher])

        store.send(Action2())

        XCTAssertTrue(catcher.actions.contains(where: { $0 is TrackedAction }))
    }

    func testTrackerProducesNoOutputForUntrackedAction() throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: Model1(), middleware: [tracker, catcher])

        store.send(Action1())

        XCTAssertFalse(catcher.actions.contains(where: { $0 is TrackedAction }))
    }

    // MARK: - Tracking Name

    func testTrackerProducesCorrectDefaultActionName() throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: Model1(), middleware: [tracker, catcher])

        store.send(Action2())

        let action = try XCTUnwrap(catcher.actions.compactMap({ $0 as? TrackedAction }).first)

        XCTAssertEqual(action.trackingName, "SubstateMiddlewareTests.ActionTrackerAsyncTests.Action2")
    }

    func testTrackerProducesCorrectDefaultNestedActionName() throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: Model1(), middleware: [tracker, catcher])

        store.send(MyActions.Action3())

        let action = try XCTUnwrap(catcher.actions.compactMap({ $0 as? TrackedAction }).first)

        XCTAssertEqual(action.trackingName, "SubstateMiddlewareTests.ActionTrackerAsyncTests.MyActions.Action3")
    }

    func testTrackerProducesCorrectCustomActionName() throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: Model1(), middleware: [tracker, catcher])

        store.send(Action4())

        let action = try XCTUnwrap(catcher.actions.compactMap({ $0 as? TrackedAction }).first)

        XCTAssertEqual(action.trackingName, "action-4-custom-id")
    }

    // MARK: - Tracking Metadata

    func testTrackerProducesCorrectDefaultActionMetadata() throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: Model1(), middleware: [tracker, catcher])

        store.send(Action2())

        let action = try XCTUnwrap(catcher.actions.compactMap({ $0 as? TrackedAction }).first)

        let metadataKeys = Array(action.trackingMetadata.keys)
        let metadataActionValue = try XCTUnwrap(action.trackingMetadata["action"] as? String)

        XCTAssertEqual(metadataKeys, ["action"])
        XCTAssertEqual(metadataActionValue, "SubstateMiddlewareTests.ActionTrackerAsyncTests.Action2")
    }

    func testTrackerProducesCorrectCustomActionMetadata() throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: Model1(), middleware: [tracker, catcher])

        store.send(Action4())

        let action = try XCTUnwrap(catcher.actions.compactMap({ $0 as? TrackedAction }).first)

        let metadataFooValue = try XCTUnwrap(action.trackingMetadata["foo"] as? Int)
        let metadataBarValue = try XCTUnwrap(action.trackingMetadata["bar"] as? String)

        XCTAssertEqual(metadataFooValue, 123)
        XCTAssertEqual(metadataBarValue, "baz")
    }

}
