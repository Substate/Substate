import XCTest
import Substate

@MainActor final class StorePerformanceTests: XCTestCase {

    struct TestAction: Action {}

    struct TestModel: Model {
        var value = 123
        mutating func update(action: Action) { value += 1 }
    }

    /// What should we be aiming for here, exactly? At present this test is just a sanity check so
    /// that the dispatch time doesn’t suddenly run away after some change to the store. Ultimately
    /// we are concerned about the performance of using reflection to traverse the model tree, and
    /// we will need some more complex tests with deep model structures to get a read on that.

    func testBasicDispatchTakesLessThanFiftyMicroseconds() async throws {
        let store = try await Store(model: TestModel())

        let iterations = 1000
        var durations: [TimeInterval] = []

        for _ in 0..<iterations {
            let start = Date()
            try await store.dispatch(TestAction())
            let end = Date()
            let duration = end.timeIntervalSince(start)
            durations.append(duration)
        }

        let sum = durations.reduce(0, +)
        let average = sum / Double(iterations)

        print("Average dispatch duration", average)
        XCTAssertLessThan(average, 0.000050)
    }

//    TODO: Get this working
//    func testStoreDispatchPerformance() async throws {
//        let store = try await Store(model: TestModel())
//
//        self.measureMetrics([.wallClockTime], automaticallyStartMeasuring: true) {
//            Task {
//                try await store.dispatch(TestAction())
//                Task { @MainActor [weak self] in
//                    self?.stopMeasuring() // EXC_BAD_ACCESS
//                }
//            }
//        }
//    }

}
