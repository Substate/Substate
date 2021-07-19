import XCTest
import SwiftUI
import Substate

final class ViewTests: XCTestCase {

    struct Counter: Substate.State {
        var value = 0
        var subCounter = SubCounter()

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

    struct SubCounter: Substate.State {
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

    struct CounterView: View {
        var body: some View {
            Container(Counter.self) { counter, dispatch in
                Text("Counter Value: \(counter.value)")
            }
        }
    }

    func testSingleContainer() throws {
        _ = CounterView()
    }

    struct CounterTotalView: View {
        var body: some View {
            Container(Counter.self) { counter, _ in
                Container(SubCounter.self) { subCounter, _ in
                    Text("Counter Total: \(counter.value + subCounter.value)")
                }
            }
        }
    }

    func testNestedContainer() throws {
        _ = CounterTotalView()
    }

}
