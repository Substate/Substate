import XCTest
import Substate

final class SubstateTests: XCTestCase {

    struct Counter: State {
        var value = 0

        struct Increment: Action {}
        struct Decrement: Action {}
        struct Reset: Action {}

        mutating func update(action: Action) {
            switch action {
            case is Increment:
                value += 1
            case is Decrement:
                value -= 1
            case is Reset:
                value = 0
            default: ()
            }
        }
    }

    func testCounter() throws {
        let store = Store(state: Counter())

        XCTAssertEqual(store.substate(Counter.self)?.value, 0)

        store.dispatch(Counter.Increment())
        XCTAssertEqual(store.substate(Counter.self)?.value, 1)

        store.dispatch(Counter.Decrement())
        store.dispatch(Counter.Decrement())
        XCTAssertEqual(store.substate(Counter.self)?.value, -1)

        store.dispatch(Counter.Reset())
        XCTAssertEqual(store.substate(Counter.self)?.value, 0)
    }
    
}
