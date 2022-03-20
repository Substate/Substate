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
        let store = try await Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        try await store.dispatch(MyUntrackedAction())

        let events = catcher.find(ActionTracker.Event.self)

        XCTAssertEqual(events.count, 0)
    }

    func testTrackerProducesEventForTrackedActions() async throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = try await Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        try await store.dispatch(MyTrackedAction())

        let events = catcher.find(ActionTracker.Event.self)

        XCTAssertEqual(events.count, 1)
    }

    // MARK: - Event Name

    func testTrackerProducesCorrectDefaultEventName() async throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = try await Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        try await store.dispatch(MyTrackedAction())

        let events = catcher.find(ActionTracker.Event.self)
        let name = try XCTUnwrap(events.first).name

        XCTAssertEqual(name, "ActionTrackerTests.MyTrackedAction")
    }

    func testTrackerProducesCorrectDefaultNestedEventName() async throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = try await Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        try await store.dispatch(MyActions.MyTrackedAction())

        let events = catcher.find(ActionTracker.Event.self)
        let name = try XCTUnwrap(events.first).name

        XCTAssertEqual(name, "ActionTrackerTests.MyActions.MyTrackedAction")
    }

    func testTrackerProducesCorrectCustomEventName() async throws {
        struct MyCustomAction: Action, TrackedAction { static let trackedName = "custom-name" }

        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = try await Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        try await store.dispatch(MyCustomAction())

        let events = catcher.actions.compactMap { $0 as? ActionTracker.Event }
        let name = try XCTUnwrap(events.first).name

        XCTAssertEqual(name, "custom-name")
    }

    // MARK: - Event Properties

    func testTrackerProducesEmptyDefaultPropertyList() async throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = try await Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        try await store.dispatch(MyTrackedAction())

        let events = catcher.find(ActionTracker.Event.self)
        let values = try XCTUnwrap(events.first).values

        XCTAssertEqual(values.count, 0)
    }

    func testTrackerProducesConstantPropertyValues() async throws {
        struct MyCustomAction: Action, TrackedAction {
            static let trackedValues: TrackedValues = [
                "custom-property": .constant("custom-property-value")
            ]
        }

        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = try await Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        try await store.dispatch(MyCustomAction())

        let events = catcher.find(ActionTracker.Event.self)
        let values = try XCTUnwrap(events.first).values
        let value = try XCTUnwrap(values["custom-property"] as? String)

        XCTAssertEqual(value, "custom-property-value")
    }

    func testTrackerProducesActionPropertyValues() async throws {
        struct MyCustomAction: Action, TrackedAction {
            let myValue = 123
            static let trackedValues: TrackedValues = [
                "custom-value": .action(\Self.myValue)
            ]
        }

        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = try await Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        try await store.dispatch(MyCustomAction())

        let events = catcher.find(ActionTracker.Event.self)
        let values = try XCTUnwrap(events.first).values
        let value = try XCTUnwrap(values["custom-value"] as? Int)

        XCTAssertEqual(value, 123)
    }

    func testTrackerProducesModelPropertyValues() async throws {
        struct MyModel: Model {
            let myValue = 456
            mutating func update(action: Action) {}
        }

        struct MyCustomAction: Action, TrackedAction {
            static let trackedValues: TrackedValues = [
                "custom-value": .model(\MyModel.myValue)
            ]
        }

        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = try await Store(model: MyModel(), middleware: [tracker, catcher])

        try await store.dispatch(MyCustomAction())

        let events = catcher.find(ActionTracker.Event.self)
        let values = try XCTUnwrap(events.first).values
        let value = try XCTUnwrap(values["custom-value"] as? Int)

        XCTAssertEqual(value, 456)
    }

}
