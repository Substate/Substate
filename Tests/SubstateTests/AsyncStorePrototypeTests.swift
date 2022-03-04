import XCTest
import Substate

@MainActor final class AsyncStorePrototypeTests: XCTestCase {

    struct MyModel: Model {
        let foo = "bar"
        mutating func update(action: Action) {}
    }

    struct Action1: Action, Equatable {}
    enum MyError: Error { case test }

    class LoggerMiddleware: Middleware {
        func configure(store: Store) -> (@escaping DispatchFunction) -> DispatchFunction {
            { next in
                { action in
                    print("ACTION", action)
                    try await next(action)
                }
            }
        }
    }

    class DelayerMiddlerware: Middleware {
        struct ScheduleSet: Action { let target: Action }
        struct ScheduleComplete: Action { let target: Action }
        func configure(store: Store) -> (@escaping DispatchFunction) -> DispatchFunction {
            { next in
                { action in
                    if action is Action1 {
                        try await store.dispatch(ScheduleSet(target: action))
                        try await Task.sleep(nanoseconds: 3 * NSEC_PER_SEC)
                        guard !Task.isCancelled else { return }
                        try await next(action)
                        try await store.dispatch(ScheduleComplete(target: action))
                    } else {
                        try await next(action)
                    }
                }
            }
        }
    }

    class ExceptionHandlerMiddlerware: Middleware {
        func configure(store: Store) -> (@escaping DispatchFunction) -> DispatchFunction {
            { next in
                { action in
                    do { try await next(action) } catch {
                        print("EXCEPTION HANDLED!")
                    }
                }
            }
        }
    }

    class ActionCatcher: Middleware {
        var actions: [Action] = []
        func find<A:Action>(_: A.Type) -> [A] {
            actions.compactMap { $0 as? A }
        }
        func configure(store: Store) -> (@escaping DispatchFunction) -> DispatchFunction {
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
        let store = try await Store(model: MyModel(), middleware: [exceptionHandler, logger, delayer, catcher])

        try await store.dispatch(Action1())
        print(catcher.actions)
        XCTAssertEqual(catcher.actions.count, 4)
        XCTAssertEqual(catcher.find(Action1.self), [Action1()])
    }

}
