import XCTest
import Substate

final class StoreTests: XCTestCase {

    struct Counter: Model {
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

    struct DeepState: Model {
        var value = 123
        struct Change: Action {}
        mutating func update(action: Action) {
            value = 456
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

    func testInitialDeeplyNestedChildState() throws {
        let store = Store(model: Counter())
        XCTAssertEqual(store.find(DeepState.self)?.value, 123)
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

//    Full recursion is not yet implemented!
//    func testDeeplyNestedChildActionDispatch() throws {
//        let store = Store(model: Counter())
//        store.update(DeepState.Change())
//        XCTAssertEqual(store.find(DeepState.self)?.value, 1)
//    }

}
