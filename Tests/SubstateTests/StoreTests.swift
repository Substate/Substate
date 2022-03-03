import XCTest
import Substate

final class StoreTests: XCTestCase {

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

    func testInitialState() throws {
        let store = Store(model: Counter())
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

    func testActionDispatch() throws {
        let store = Store(model: Counter())

        store.send(Counter.Increment())
        XCTAssertEqual(store.find(Counter.self)?.value, 1)

        store.send(Counter.Decrement())
        store.send(Counter.Decrement())
        XCTAssertEqual(store.find(Counter.self)?.value, -1)

        store.send(Counter.Reset(toValue: 100))
        XCTAssertEqual(store.find(Counter.self)?.value, 100)
    }

    func testChildActionDispatch() throws {
        let store = Store(model: Counter())

        store.send(Counter.Increment())
        XCTAssertEqual(store.find(Counter.self)?.value, 1)

        store.send(SubCounter.Increment())
        XCTAssertEqual(store.find(SubCounter.self)?.value, 1)
    }

    func testReplaceAction() throws {
        let store = Store(model: Counter(value: 123))

        store.send(Store.Replace(model: Counter(value: 456)))
        XCTAssertEqual(store.find(Counter.self)?.value, 456)
        // Double-check child model state was not changed
        XCTAssertEqual(store.find(SubCounter.self)?.value, 0)

        store.send(Store.Replace(model: SubCounter(value: 789)))
        XCTAssertEqual(store.find(SubCounter.self)?.value, 789)
        // Double-check parent model state was not changed
        XCTAssertEqual(store.find(Counter.self)?.value, 456)
    }

    func testDeeplyNestedChildActionDispatch() throws {
        let store = Store(model: Counter())

        store.send(NestedState.Change())
        XCTAssertEqual(store.find(NestedState.self)?.value, 456)
        XCTAssertEqual(store.find(Counter.self)?.value, 10000)
    }

    func testParentModelSeesChangesInChild() throws {
        let store = Store(model: Counter())

        store.send(SubCounter.Increment())
        XCTAssertEqual(store.find(Counter.self)?.subCounterValueWasChanged, true)
    }

}
