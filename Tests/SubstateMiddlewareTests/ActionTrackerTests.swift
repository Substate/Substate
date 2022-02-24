import XCTest
import Combine

import Substate
import SubstateMiddleware

final class ActionTrackerTests: XCTestCase {

    struct MyUntrackedAction: Action {}
    struct MyTrackedAction: Action, TrackedAction {}

    enum MyActions { struct MyTrackedAction: Action, TrackedAction {} }

    struct MyEmptyModel: Model { mutating func update(action: Action) {} }

    // MARK: - Event Output

    func testTrackerProducesNoEventForUntrackedActions() throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        store.send(MyUntrackedAction())

        let events = catcher.find(ActionTracker.Event.self)

        XCTAssertEqual(events.count, 0)
    }

    func testTrackerProducesEventForTrackedActions() throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        store.send(MyTrackedAction())

        let events = catcher.find(ActionTracker.Event.self)

        XCTAssertEqual(events.count, 1)
    }

    // MARK: - Event Name

    func testTrackerProducesCorrectDefaultEventName() throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        store.send(MyTrackedAction())

        let events = catcher.find(ActionTracker.Event.self)
        let name = try XCTUnwrap(events.first).name

        XCTAssertEqual(name, "SubstateMiddlewareTests.ActionTrackerTests.MyTrackedAction")
    }

    func testTrackerProducesCorrectDefaultNestedEventName() throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        store.send(MyActions.MyTrackedAction())

        let events = catcher.find(ActionTracker.Event.self)
        let name = try XCTUnwrap(events.first).name

        XCTAssertEqual(name, "SubstateMiddlewareTests.ActionTrackerTests.MyActions.MyTrackedAction")
    }

    func testTrackerProducesCorrectCustomEventName() throws {
        struct MyCustomAction: Action, TrackedAction { let trackingName = "custom-name" }

        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        store.send(MyCustomAction())

        let events = catcher.actions.compactMap { $0 as? ActionTracker.Event }
        let name = try XCTUnwrap(events.first).name

        XCTAssertEqual(name, "custom-name")
    }

    // MARK: - Event Properties

    func testTrackerProducesEmptyDefaultPropertyList() throws {
        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        store.send(MyTrackedAction())

        let events = catcher.find(ActionTracker.Event.self)
        let properties = try XCTUnwrap(events.first).properties

        XCTAssertEqual(properties.count, 0)
    }

    func testTrackerProducesConstantPropertyValues() throws {
        struct MyCustomAction: Action, TrackedAction {
            let trackingProperties: [String : Any] = [
                "custom-property": "custom-property-value"
            ]
        }

        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        store.send(MyCustomAction())

        let events = catcher.find(ActionTracker.Event.self)
        let properties = try XCTUnwrap(events.first).properties
        let value = try XCTUnwrap(properties["custom-property"] as? String)

        XCTAssertEqual(value, "custom-property-value")
    }

    func testTrackerProducesActionPropertyValues() throws {
        struct MyCustomAction: Action, TrackedAction {
            let myValue = 123
            let trackingProperties: [String : Any] = [
                "custom-property": TrackedValue(\Self.myValue)
            ]
        }

        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: MyEmptyModel(), middleware: [tracker, catcher])

        store.send(MyCustomAction())

        let events = catcher.find(ActionTracker.Event.self)
        let properties = try XCTUnwrap(events.first).properties
        let value = try XCTUnwrap(properties["custom-property"] as? Int)

        XCTAssertEqual(value, 123)
    }

    func testTrackerProducesModelPropertyValues() throws {
        struct MyModel: Model {
            let myValue = 456
            mutating func update(action: Action) {}
        }

        struct MyCustomAction: Action, TrackedAction {
            let trackingProperties: [String : Any] = [
                "custom-property": TrackedValue(\MyModel.myValue)
            ]
        }

        let tracker = ActionTracker()
        let catcher = ActionCatcher()
        let store = Store(model: MyModel(), middleware: [tracker, catcher])

        store.send(MyCustomAction())

        let events = catcher.find(ActionTracker.Event.self)
        let properties = try XCTUnwrap(events.first).properties
        let value = try XCTUnwrap(properties["custom-property"] as? Int)

        XCTAssertEqual(value, 456)
    }

}
