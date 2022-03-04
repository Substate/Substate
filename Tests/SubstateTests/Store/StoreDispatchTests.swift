import XCTest
import Substate

@MainActor final class StoreDispatchTests: XCTestCase {

    struct Counter: Model {
        var value = 0
        var child = ChildCounter()
        var childIncremented = false

        struct Increment: Action {}
        struct Decrement: Action {}

        mutating func update(action: Action) {
            if action is Increment { value += 1 }
            if action is Decrement { value -= 1 }
            if action is ChildCounter.Increment { childIncremented = child.value != 0 }
        }
    }

    struct ChildCounter: Model {
        var value = 0

        struct Increment: Action {}
        struct Decrement: Action {}

        mutating func update(action: Action) {
            if action is Increment { value += 1 }
            if action is Decrement { value -= 1 }
        }
    }

    func testActionUpdatesModel() async throws {
        let store = try await Store(model: Counter())

        try await store.dispatch(Counter.Increment())
        XCTAssertEqual(store.find(Counter.self)?.value, 1)
    }

    func testMultipleActionsUpdateModel() async throws {
        let store = try await Store(model: Counter())

        try await store.dispatch(Counter.Decrement())
        try await store.dispatch(Counter.Decrement())
        XCTAssertEqual(store.find(Counter.self)?.value, -2)

        try await store.dispatch(Counter.Increment())
        try await store.dispatch(Counter.Increment())
        try await store.dispatch(Counter.Increment())
        XCTAssertEqual(store.find(Counter.self)?.value, 1)
    }

    func testChildActionUpdatesChildModel() async throws {
        let store = try await Store(model: Counter())

        try await store.dispatch(ChildCounter.Increment())
        XCTAssertEqual(store.find(ChildCounter.self)?.value, 1)

        // Double-check outer model state was not changed
        XCTAssertEqual(store.find(Counter.self)?.value, 0)
    }

    func testParentModelSeesChangesInChild() async throws {
        let store = try await Store(model: Counter())

        try await store.dispatch(ChildCounter.Increment())
        XCTAssertEqual(store.find(Counter.self)?.childIncremented, true)
    }

}
