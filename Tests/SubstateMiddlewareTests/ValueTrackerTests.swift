import XCTest

import Substate
import SubstateMiddleware

@MainActor final class ValueTrackerTests: XCTestCase {

    struct MyModel: Model {
        var value: Int = 123
        var value2: Int = 789
        struct Update: Action {}
        struct Passthrough: Action {}
        mutating func update(action: Action) {
            if action is Update {
                value = 456
            }
        }
    }

    // MARK: - Event Output

    func testTrackerProducesSingleInitialEvent() async throws {
        let values: TrackedValues = [
            "model-value": .model(\MyModel.value)
        ]

        let catcher = ActionCatcher()
        let tracker = ValueTracker(values: values)
        _ = try await Store(model: MyModel(), middleware: [tracker, catcher])

        let events = catcher.find(ValueTracker.Event.self)

        XCTAssertEqual(events.count, 1)
    }

    func testTrackerProducesCorrectInitialModelValue() async throws {
        let values: TrackedValues = [
            "model-value": .model(\MyModel.value)
        ]

        let catcher = ActionCatcher()
        let tracker = ValueTracker(values: values)
        _ = try await Store(model: MyModel(), middleware: [tracker, catcher])

        let events = catcher.find(ValueTracker.Event.self)
        let event = try XCTUnwrap(events.first)
        let value = try XCTUnwrap(event.value as? Int)

        XCTAssertEqual(value, 123)
    }

    func testTrackerProducesCorrectModelValueAfterUpdate() async throws {
        let values: TrackedValues = [
            "model-value": .model(\MyModel.value)
        ]

        let catcher = ActionCatcher()
        let tracker = ValueTracker(values: values)
        let store = try await Store(model: MyModel(), middleware: [tracker, catcher])

        try await store.dispatch(MyModel.Update())

        let events = catcher.find(ValueTracker.Event.self)
        let event = try XCTUnwrap(events.last)
        let value = try XCTUnwrap(event.value as? Int)

        XCTAssertEqual(value, 456)
    }

    func testTrackerIgnoresUnrelatedActions() async throws {
        let values: TrackedValues = [
            "model-value": .model(\MyModel.value)
        ]

        let catcher = ActionCatcher()
        let tracker = ValueTracker(values: values)
        let store = try await Store(model: MyModel(), middleware: [tracker, catcher])

        try await store.dispatch(MyModel.Passthrough())
        try await store.dispatch(MyModel.Passthrough())
        try await store.dispatch(MyModel.Passthrough())

        let events = catcher.find(ValueTracker.Event.self)
        XCTAssertEqual(events.count, 1)
    }

    func testTrackerProducesEventsAfterIgnoringUnrelatedActions() async throws {
        let values: TrackedValues = [
            "model-value": .model(\MyModel.value)
        ]

        let catcher = ActionCatcher()
        let tracker = ValueTracker(values: values)
        let store = try await Store(model: MyModel(), middleware: [tracker, catcher])

        try await store.dispatch(MyModel.Passthrough())
        try await store.dispatch(MyModel.Passthrough())
        try await store.dispatch(MyModel.Passthrough())
        try await store.dispatch(MyModel.Update())

        let events = catcher.find(ValueTracker.Event.self)
        XCTAssertEqual(events.count, 2)
    }

    func testTrackerProducesCorrectNamesForEvents() async throws {
        let values: TrackedValues = [
            "model-value-1": .model(\MyModel.value),
            "model-value-2": .model(\MyModel.value2)
        ]

        let catcher = ActionCatcher()
        let tracker = ValueTracker(values: values)
        _ = try await Store(model: MyModel(), middleware: [tracker, catcher])

        let events = catcher.find(ValueTracker.Event.self)

        XCTAssertEqual(events.count, 2)
        XCTAssertTrue(events.contains { $0.name == "model-value-1" })
        XCTAssertTrue(events.contains { $0.name == "model-value-2" })
    }

}
