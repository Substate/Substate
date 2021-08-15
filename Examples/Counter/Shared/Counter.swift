import Foundation
import Substate
import SubstateMiddleware

struct Counter: Model, SavedModel {

    var value = 0

    var canReset: Bool { value != 0 }
    var canIncrement: Bool { value < .max }
    var canDecrement: Bool { value > .min }

    struct Reset: Action {}
    struct Increment: Action {}
    struct Decrement: Action {}

    mutating func update(action: Action) {
        switch action {

        case is Reset:
            if canReset { value = 0 }

        case is Increment:
            if canIncrement { value += 1 }

        case is Decrement:
            if canDecrement { value -= 1 }

        default: ()
        }
    }

}

extension Counter {

    static let zero = Counter(value: 0)
    static let random = Counter(value: .random(in: 1...1000))
    static let max = Counter(value: .max)

}
