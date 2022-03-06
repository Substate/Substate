import XCTest
import Substate
import SubstateMiddleware

@MainActor final class ActionLoggerTests: XCTestCase {

    struct Action1: Action {}
    struct Action2: Action, LoggedAction { let property: Int }
    struct Action3: Action, LoggedAction { let property: Int }

    struct Component: Model {
        mutating func update(action: Action) {}
    }

    func testStartActionIsLoggedDuringSetup() async throws {
        var output = ""
        let logger = ActionLogger { output.append($0 + "\n") }
        _ = try await Store(model: Component(), middleware: [logger])
        print(output)
        XCTAssert(output.contains("ActionLogger.Start"))
    }

    func testAllActionsAreLoggedByDefault() async throws {
        var output = ""
        let logger = ActionLogger { output.append($0) }
        let store = try await Store(model: Component(), middleware: [logger])
        try await store.dispatch(Action1())
        XCTAssert(output.contains("Action1"))
        try await store.dispatch(Action2(property: 1))
        XCTAssert(output.contains("Action2"))
        try await store.dispatch(Action3(property: 2))
        XCTAssert(output.contains("Action3"))
    }

    func testAllActionsAreLoggedWhenFilterIsInactive() async throws {
        var output = ""
        let logger = ActionLogger(filter: false) { output.append($0) }
        let store = try await Store(model: Component(), middleware: [logger])
        try await store.dispatch(Action1())
        XCTAssert(output.contains("Action1"))
        try await store.dispatch(Action2(property: 1))
        XCTAssert(output.contains("Action2"))
        try await store.dispatch(Action3(property: 2))
        XCTAssert(output.contains("Action3"))
    }

    func testTaggedActionsAreLoggedWhenFilterIsActive() async throws {
        var output = ""
        let logger = ActionLogger(filter: true) { output.append($0) }
        let store = try await Store(model: Component(), middleware: [logger])
        try await store.dispatch(Action2(property: 1))
        XCTAssert(output.contains("Action2"))
        try await store.dispatch(Action3(property: 2))
        XCTAssert(output.contains("Action3"))
    }

    func testUntaggedActionsAreNotLoggedWhenFilterIsActive() async throws {
        var output = ""
        let logger = ActionLogger(filter: true) { output.append($0) }
        let store = try await Store(model: Component(), middleware: [logger])
        try await store.dispatch(Action1())
        XCTAssertFalse(output.contains("Action1"))
    }

    func testActionPropertiesAreLogged() async throws {
        var output = ""
        let logger = ActionLogger { output.append($0) }
        let store = try await Store(model: Component(), middleware: [logger])
        try await store.dispatch(Action2(property: 1))
        XCTAssert(output.contains("property: 1"))
        try await store.dispatch(Action3(property: 2))
        XCTAssert(output.contains("property: 2"))
    }

    func testRealConsoleOutput() async throws {
        let store = try await Store(model: Component(), middleware: [ActionLogger()])
        try await store.dispatch(Action1())
        try await store.dispatch(Action2(property: 1))
        try await store.dispatch(Action3(property: 2))
    }

    func testStopActionDisablesOutput() async throws {
        var output = ""
        let logger = ActionLogger { output.append($0) }
        let store = try await Store(model: Component(), middleware: [logger])
        try await store.dispatch(ActionLogger.Stop())
        output = ""
        try await store.dispatch(Action1())
        XCTAssertEqual(output, "")
    }

    func testStartActionReenablesOutput() async throws {
        var output = ""
        let logger = ActionLogger { output.append($0) }
        let store = try await Store(model: Component(), middleware: [logger])
        try await store.dispatch(ActionLogger.Stop())
        output = ""
        try await store.dispatch(ActionLogger.Start())
        try await store.dispatch(Action1())
        XCTAssertNotEqual(output, "")
    }

    func testLoggerStateIsAvailable() async throws {
        let store = try await Store(model: Component(), middleware: [ActionLogger()])
        XCTAssertNotNil(store.find(ActionLogger.Configuration.self))
    }

    func testLoggerStateIsInitiallyActive() async throws {
        let store = try await Store(model: Component(), middleware: [ActionLogger()])
        XCTAssertTrue(try XCTUnwrap(store.find(ActionLogger.Configuration.self)).isActive)
    }

    func testLoggerStateChangesWhenStartAndStopAreDispatched() async throws {
        let store = try await Store(model: Component(), middleware: [ActionLogger()])
        try await store.dispatch(ActionLogger.Stop())
        XCTAssertFalse(try XCTUnwrap(store.find(ActionLogger.Configuration.self)).isActive)
        try await store.dispatch(ActionLogger.Start())
        XCTAssertTrue(try XCTUnwrap(store.find(ActionLogger.Configuration.self)).isActive)
    }

}
