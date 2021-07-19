import XCTest
import Substate

final class SubstateTests: XCTestCase {

    struct Counter: State {
        var value = 0

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

    func testCounter() throws {
        let store = Store(state: Counter())

        XCTAssertEqual(store.state(Counter.self)?.value, 0)

        store.dispatch(Counter.Increment())
        XCTAssertEqual(store.state(Counter.self)?.value, 1)

        store.dispatch(Counter.Decrement())
        store.dispatch(Counter.Decrement())
        XCTAssertEqual(store.state(Counter.self)?.value, -1)

        store.dispatch(Counter.Reset(toValue: 100))
        XCTAssertEqual(store.state(Counter.self)?.value, 100)
    }
    
}
