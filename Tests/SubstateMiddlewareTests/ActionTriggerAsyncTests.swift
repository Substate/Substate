import XCTest
import Combine
import Substate
import SubstateMiddleware

@testable import SubstateMiddleware

final class ActionTriggerAsyncTests: XCTestCase {

    struct Action1: Action, Equatable {
        let int: Int = 1
        let double: Double = 2
        let string: String = "3"
    }

    struct Action2: Action, Equatable {}

    struct Model1: Model, Equatable {
        let int: Int = 4
        let double: Double = 5
        let string: String = "6"
        mutating func update(action: Action) {}
    }

    let find: (Model.Type) -> Model? = {
        $0 == Model1.self ? Model1() : nil
    }

    // MARK: - Async Effects

    func test_async_effect2() async throws {
        let _: ActionTriggerStep1<Void> =
            Action1
                .perform { try await Task.sleep(nanoseconds: 1) }
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

        let result = await triggers.run(action: Action1(), find: find).reduce([]) { $0 + [$1] }

        XCTAssertEqual(try XCTUnwrap(result[0] as? Action2), Action2())
        XCTAssertEqual(try XCTUnwrap(result[1] as? Action2), Action2())
        XCTAssertEqual(try XCTUnwrap(result[2] as? Action2), Action2())
    }

    func testSubscribingToAsyncStream() async throws {
//        class Service {
//            var results: AsyncStream<Int> {
//                AsyncStream { continuation in
//                    for i in 0..<10 {
//                        continuation.yield(i)
//                    }
//                    continuation.finish()
//                }
//            }
//        }
//
//        let triggers = ActionTriggers {
//            let service = Service()
//
//            Action1
//                .subscribe(to: service.results)
//                .trigger(Action2())
//        }
//
//        let result = await triggers.run(action: Action1(), find: find).reduce([]) { $0 + [$1] }
//        print(result)
    }
    
}
