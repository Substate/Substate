import XCTest
import Substate

@MainActor final class AsyncStorePrototypeTests: XCTestCase {

    struct MyModel: Model {
        let foo = "bar"
        mutating func update(action: Action) {}
    }

    struct Action1: Action, Equatable {}
    enum MyError: Error { case test }

    class LoggerMiddleware: AsyncMiddleware {
        func run(dispatch: @escaping DispatchFunction) -> (@escaping DispatchFunction) -> DispatchFunction {
            { next in
                { action in
                    print("ACTION", action)
                    // throw MyError.test
                    try await next(action)
                }
            }
        }
    }

    class DelayerMiddlerware: AsyncMiddleware {
        struct ScheduleSet: Action { let target: Action }
        struct ScheduleComplete: Action { let target: Action }
        func run(dispatch: @escaping DispatchFunction) -> (@escaping DispatchFunction) -> DispatchFunction {
            { next in
                { action in
                    if action is Action1 {
                        try await dispatch(ScheduleSet(target: action))
                        try await Task.sleep(nanoseconds: 3 * NSEC_PER_SEC)
                        try await next(action)
                        try await dispatch(ScheduleComplete(target: action))
                    } else {
                        try await next(action)
                    }
                }
            }
        }
    }

    class ExceptionHandlerMiddlerware: AsyncMiddleware {
        func run(dispatch: @escaping DispatchFunction) -> (@escaping DispatchFunction) -> DispatchFunction {
            { next in
                { action in
                    do { try await next(action) } catch {
                        print("EXCEPTION HANDLED!")
                    }
                }
            }
        }
    }

    class ActionCatcher: AsyncMiddleware {
        var actions: [Action] = []
        func find<A:Action>(_: A.Type) -> [A] {
            actions.compactMap { $0 as? A }
        }
        func run(dispatch: @escaping DispatchFunction) -> (@escaping DispatchFunction) -> DispatchFunction {
            { next in
                { action in
                    self.actions.append(action)
                    try await next(action)
                }
            }
        }
    }

    func testStore() async throws {
        let logger = LoggerMiddleware()
        let delayer = DelayerMiddlerware()
        let exceptionHandler = ExceptionHandlerMiddlerware()
        let catcher = ActionCatcher()
        let store = AsyncStorePrototype(state: MyModel(), middleware: [exceptionHandler, logger, delayer, catcher])

        await store.dispatch(action: Action1())
        XCTAssertEqual(catcher.actions.count, 3)
        XCTAssertEqual(catcher.find(Action1.self), [Action1()])
    }

}
