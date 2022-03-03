import XCTest
import Combine

import Substate
import SubstateMiddleware

@MainActor final class ActionTrackerTests: XCTestCase {

    struct MyUntrackedAction: Action {}
    struct MyTrackedAction: Action, TrackedAction {}

    enum MyActions { struct MyTrackedAction: Action, TrackedAction {} }

    struct MyEmptyModel: Model { mutating func update(action: Action) {} }

    // MARK: - Event Output

    func testTrackerProducesNoEventForUntrackedActions() async throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        try await store.dispatch(MyUntrackedAction())

        let events = catcher.find(ActionTracker.Event.self)

        XCTAssertEqual(events.count, 0)
    }

    func testTrackerProducesEventForTrackedActions() async throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        try await store.dispatch(MyTrackedAction())

        let events = catcher.find(ActionTracker.Event.self)

        XCTAssertEqual(events.count, 1)
    }

    // MARK: - Event Name

    func testTrackerProducesCorrectDefaultEventName() async throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        try await store.dispatch(MyTrackedAction())

        let events = catcher.find(ActionTracker.Event.self)
        let name = try XCTUnwrap(events.first).name

        XCTAssertEqual(name, "SubstateMiddlewareTests.ActionTrackerTests.MyTrackedAction")
    }

    func testTrackerProducesCorrectDefaultNestedEventName() async throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        try await store.dispatch(MyActions.MyTrackedAction())

        let events = catcher.find(ActionTracker.Event.self)
        let name = try XCTUnwrap(events.first).name

        XCTAssertEqual(name, "SubstateMiddlewareTests.ActionTrackerTests.MyActions.MyTrackedAction")
    }

    func testTrackerProducesCorrectCustomEventName() async throws {
        struct MyCustomAction: Action, TrackedAction { let trackingName = "custom-name" }

        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        try await store.dispatch(MyCustomAction())

        let events = catcher.actions.compactMap { $0 as? ActionTracker.Event }
        let name = try XCTUnwrap(events.first).name

        XCTAssertEqual(name, "custom-name")
    }

    // MARK: - Event Properties

    func testTrackerProducesEmptyDefaultPropertyList() async throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        try await store.dispatch(MyTrackedAction())

        let events = catcher.find(ActionTracker.Event.self)
        let properties = try XCTUnwrap(events.first).properties

        XCTAssertEqual(properties.count, 0)
    }

    func testTrackerProducesConstantPropertyValues() async throws {
        struct MyCustomAction: Action, TrackedAction {
            let trackingProperties: [String : Any] = [
                "custom-property": "custom-property-value"
            ]
        }

        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        try await store.dispatch(MyCustomAction())

        let events = catcher.find(ActionTracker.Event.self)
        let properties = try XCTUnwrap(events.first).properties
        let value = try XCTUnwrap(properties["custom-property"] as? String)

        XCTAssertEqual(value, "custom-property-value")
    }

    func testTrackerProducesActionPropertyValues() async throws {
        @MainActor struct MyCustomAction: Action, TrackedAction {
            let myValue = 123
            let trackingProperties: [String : Any] = [
                "custom-property": TrackedValue(\Self.myValue)
            ]
        }

        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        try await store.dispatch(MyCustomAction())

        let events = catcher.find(ActionTracker.Event.self)
        let properties = try XCTUnwrap(events.first).properties
        let value = try XCTUnwrap(properties["custom-property"] as? Int)

        XCTAssertEqual(value, 123)
    }

    func testTrackerProducesModelPropertyValues() async throws {
        struct MyModel: Model {
            let myValue = 456
            mutating func update(action: Action) {}
        }

        @MainActor struct MyCustomAction: Action, TrackedAction {
            let trackingProperties: [String : Any] = [
                "custom-property": TrackedValue(\MyModel.myValue)
            ]
        }

        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: MyModel(), middleware: [tracker, catcher])

        try await store.dispatch(MyCustomAction())

        let events = catcher.find(ActionTracker.Event.self)
        let properties = try XCTUnwrap(events.first).properties
        let value = try XCTUnwrap(properties["custom-property"] as? Int)

        XCTAssertEqual(value, 456)
    }

}
