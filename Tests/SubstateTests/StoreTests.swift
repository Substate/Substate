import XCTest
import Substate

final class StoreTests: XCTestCase {

    struct Counter: State {
        var value = 0
        var subCounter = SubCounter()
        var container = Container()

        struct Increment: Action {}
        struct Decrement: Action {}

        struct Reset: Action {
            let toValue: Int
        }

        mutating func update(action: Action) {
            switch action {
            case is Increment: value += 1
            case is Decrement: value -= 1
            case let action as Reset: value = action.toValue
            default: ()
            }
        }
    }

    struct SubCounter: State {
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
        var container2 = Container2()
        struct Container2 {
            var container3 = Container3()
            struct Container3 {
                var container4 = Container4()
                struct Container4 {
                    var deepState = DeepState()
                }
            }
        }
    }

    struct DeepState: State {
        var value = 123
        struct Change: Action {}
        mutating func update(action: Action) {
            value = 456
        }
    }

    func testInitialState() throws {
        let store = Store(state: Counter())
        XCTAssertEqual(store.select(Counter.self)?.value, 0)
    }

    func testInitialChildState() throws {
        let store = Store(state: Counter())
        XCTAssertEqual(store.select(SubCounter.self)?.value, 0)
    }

    func testInitialDeeplyNestedChildState() throws {
        let store = Store(state: Counter())
        XCTAssertEqual(store.select(DeepState.self)?.value, 123)
    }

    func testActionDispatch() throws {
        let store = Store(state: Counter())

        store.update(Counter.Increment())
        XCTAssertEqual(store.select(Counter.self)?.value, 1)

        store.update(Counter.Decrement())
        store.update(Counter.Decrement())
        XCTAssertEqual(store.select(Counter.self)?.value, -1)

        store.update(Counter.Reset(toValue: 100))
        XCTAssertEqual(store.select(Counter.self)?.value, 100)
    }

    func testChildActionDispatch() throws {
        let store = Store(state: Counter())

        store.update(SubCounter.Increment())
        XCTAssertEqual(store.select(SubCounter.self)?.value, 1)
    }

    func testDeeplyNestedChildActionDispatch() throws {
        XCTExpectFailure("Full recursion is not yet implemented")

        let store = Store(state: Counter())
        store.update(DeepState.Change())
        XCTAssertEqual(store.select(DeepState.self)?.value, 1)
    }

}
