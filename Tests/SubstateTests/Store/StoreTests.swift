import XCTest
import Substate

@MainActor final class StoreTests: XCTestCase {

    struct Counter: Model {
        var value = 0
        var subCounter = SubCounter()
        var container = Container()
        var subCounterValueWasChanged = false

        struct Increment: Action {}
        struct Decrement: Action {}

        struct Reset: Action {
            let toValue: Int
        }

        mutating func update(action: Action) {
            switch action {
            case is Increment: value += 1
            case is Decrement: value -= 1
            case is NestedState.Change: value = 10000
            case let action as Reset: value = action.toValue
            default: ()
            }

            subCounterValueWasChanged = subCounter.value != 0
        }
    }

    struct SubCounter: Model {
        var value = 0

        struct Increment: Action {}
        struct Decrement: Action {}

        mutating func update(action: Action) {
            switch action {
            case is Increment: value += 1
            case is Decrement: value -= 1
            default: ()
            }
        }
    }

    struct Container {
        var nestedState = NestedState()
    }

    struct NestedState: Model {
        var value = 123
        struct Change: Action {}
        mutating func update(action: Action) {
            if action is Change {
                value = 456
            }
        }
    }

    func testInitialState() async throws {
        let store = try await Store(model: Counter())
        XCTAssertEqual(store.find(Counter.self)?.value, 0)
    }

    func testInitialChildState() throws {
        let store = Store(model: Counter())
        XCTAssertEqual(store.find(SubCounter.self)?.value, 0)
    }

    func testInitialNestedChildState() throws {
        let store = Store(model: Counter())
        XCTAssertEqual(store.find(NestedState.self)?.value, 123)
    }

    func testActionDispatch() async throws {
        let store = try await Store(model: Counter())

        try await store.dispatch(Counter.Increment())
        XCTAssertEqual(store.find(Counter.self)?.value, 1)

        try await store.dispatch(Counter.Decrement())
        try await store.dispatch(Counter.Decrement())
        XCTAssertEqual(store.find(Counter.self)?.value, -1)

        try await store.dispatch(Counter.Reset(toValue: 100))
        XCTAssertEqual(store.find(Counter.self)?.value, 100)
    }

    func testChildActionDispatch() async throws {
        let store = try await Store(model: Counter())

        try await store.dispatch(Counter.Increment())
        XCTAssertEqual(store.find(Counter.self)?.value, 1)

        try await store.dispatch(SubCounter.Increment())
        XCTAssertEqual(store.find(SubCounter.self)?.value, 1)
    }

    func testReplaceAction() async throws {
        let store = try await Store(model: Counter(value: 123))

        try await store.dispatch(Store.Replace(model: Counter(value: 456)))
        XCTAssertEqual(store.find(Counter.self)?.value, 456)
        // Double-check child model state was not changed
        XCTAssertEqual(store.find(SubCounter.self)?.value, 0)

        try await store.dispatch(Store.Replace(model: SubCounter(value: 789)))
        XCTAssertEqual(store.find(SubCounter.self)?.value, 789)
        // Double-check parent model state was not changed
        XCTAssertEqual(store.find(Counter.self)?.value, 456)
    }

    func testDeeplyNestedChildActionDispatch() async throws {
        let store = try await Store(model: Counter())

        try await store.dispatch(NestedState.Change())
        XCTAssertEqual(store.find(NestedState.self)?.value, 456)
        XCTAssertEqual(store.find(Counter.self)?.value, 10000)
    }

    func testParentModelSeesChangesInChild() async throws {
        let store = try await Store(model: Counter())

        try await store.dispatch(SubCounter.Increment())
        XCTAssertEqual(store.find(Counter.self)?.subCounterValueWasChanged, true)
    }

//    TODO: Make this work and test dispatch performance.
//    func testDispatchPerformance() async throws {
//        let store = Store(model: Counter())
//        self.measureMetrics([.wallClockTime], automaticallyStartMeasuring: true) {
//            Task { @MainActor in
//                self.startMeasuring()
//                try await store.dispatch(Counter.Increment())
//                self.stopMeasuring()
//            }
//        }
//    }

}
