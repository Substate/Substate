import XCTest
import Combine

@testable import Substate
@testable import SubstateMiddleware

@MainActor class ActionTriggerAsyncTests: XCTestCase {

    var store: Store!

    @MainActor override func setUp() {
        store = Store(model: Model1())
    }

    struct Action1: Action, Equatable {
        let int: Int = 1
        let double: Double = 2
        let string: String = "3"
    }

    struct Action2: Action, Equatable {}

    struct Action3: Action, Equatable {
        let int: Int
    }

    struct Model1: Model, Equatable {
        let int: Int = 4
        let double: Double = 5
        let string: String = "6"
        mutating func update(action: Action) {}
    }

    // MARK: - Async Effects

    func testPerformAsyncClosure() async throws {
        let step: ActionTriggerStepFinal<Action2> =
            Action1
                .perform { try await Task.sleep(nanoseconds: 1) }
                .trigger(Action2())

        let result = await step.run(action: Action1(), store: store).reduce([]) { $0 + [$1] }
        XCTAssertEqual(result[0], Action2())
    }

    func testPerformVariantDeclarations() async throws {
        let _: ActionTriggerStepFinal<VoidAction> =
            Action1
                .perform { try await Task.sleep(nanoseconds: 1) }

        let _: ActionTriggerStepFinal<VoidAction> =
            Action1
                .perform { action in try await Task.sleep(nanoseconds: 1) }

        let _: ActionTriggerStepFinal<Action2> =
            Action1
                .perform { try await Task.sleep(nanoseconds: 1) }
                .trigger(Action2())

        let _: ActionTriggerStepFinal<Action2> =
            Action1
                .perform { action in try await Task.sleep(nanoseconds: 1) }
                .trigger(Action2())
    }

    func testParallelExecution() async throws {
        // let longSleepTime: UInt64 = 3 * 1_000_000_000
        let shortSleepTime: UInt64 = 1

        // Change to long to check parallel execution.
        // In the long case, the test should last 3 seconds, not 3*3 seconds.
        let sleepTime = shortSleepTime

        let triggers = ActionTriggers {
            Action1
                .perform { try await Task.sleep(nanoseconds: sleepTime) }
                .trigger(Action2())

            Action1
                .perform { try await Task.sleep(nanoseconds: sleepTime) }
                .trigger(Action2())

            Action1
                .perform { try await Task.sleep(nanoseconds: sleepTime) }
                .trigger(Action2())
        }

        let result = await triggers.run(action: Action1(), store: store).reduce([]) { $0 + [$1] }

        XCTAssertEqual(try XCTUnwrap(result[0] as? Action2), Action2())
        XCTAssertEqual(try XCTUnwrap(result[1] as? Action2), Action2())
        XCTAssertEqual(try XCTUnwrap(result[2] as? Action2), Action2())
    }

    class NumberService {
        @Published var currentNumber: Int = 0
        var numbers: AsyncStream<Int> {
            AsyncStream { continuation in
                for i in 0..<10 {
                    continuation.yield(i)
                }
                continuation.finish()
            }
        }
    }

    struct NumberAction: Action, Equatable {
        let number: Int
    }

    func testAsyncSequenceTriggerWithoutValue() async throws {
        let triggers = ActionTriggers {
            let service = NumberService()

            service.numbers
                .trigger(Action2())
        }

        let result = await triggers.run(action: Store.Start(), store: store).reduce([]) { $0 + [$1] }
        XCTAssertEqual(try XCTUnwrap(result[0] as? Action2), Action2())
    }

    func testAsyncSequenceTriggerWithValue() async throws {
        let triggers = ActionTriggers {
            let service = NumberService()

            service.numbers
                .trigger { NumberAction.init(number: $0) }
        }

        let result = await triggers.run(action: Store.Start(), store: store).reduce([]) { $0 + [$1] }
        XCTAssertEqual(try XCTUnwrap(result[0] as? NumberAction), NumberAction(number: 0))
        XCTAssertEqual(try XCTUnwrap(result[9] as? NumberAction), NumberAction(number: 9))
    }

    func testPublishedTriggerWithoutValue() async throws {
        let service = NumberService()

        let triggers = ActionTriggers {
            service.$currentNumber
                .trigger(Action2())
        }

        let result = await triggers.run(action: Store.Start(), store: store).prefix(1).reduce([]) { $0 + [$1] }
        XCTAssertEqual(try XCTUnwrap(result[0] as? Action2), Action2())
    }

    func testPublishedTriggerWithValue() async throws {
        let service = NumberService()

        let triggers = ActionTriggers {
            service.$currentNumber
                .trigger { NumberAction.init(number: $0) }
        }

        service.currentNumber = 5
        let result = await triggers.run(action: Store.Start(), store: store).prefix(1).reduce([]) { $0 + [$1] }
        XCTAssertEqual(try XCTUnwrap(result[0] as? NumberAction), NumberAction(number: 5))
    }

}
