import XCTest
import Substate
import SubstateMiddleware

final class ActionLoggerTests: XCTestCase {

    struct Action1: Action {}
    struct Action2: Action, LoggedAction { let property: Int }
    struct Action3: Action, LoggedAction { let property: Int }

    struct Component: Model {
        mutating func update(action: Action) {}
    }

    func testStartActionIsLoggedDuringSetup() throws {
        var output = ""
        let logger = ActionLogger { output.append($0) }
        _ = Store(model: Component(), middleware: [logger])
        XCTAssert(output.contains("ActionLogger.Start"))
    }

    func testAllActionsAreLoggedByDefault() throws {
        var output = ""
        let logger = ActionLogger { output.append($0) }
        let store = Store(model: Component(), middleware: [logger])
        store.update(Action1())
        XCTAssert(output.contains("Action1"))
        store.update(Action2(property: 1))
        XCTAssert(output.contains("Action2"))
        store.update(Action3(property: 2))
        XCTAssert(output.contains("Action3"))
    }

    func testAllActionsAreLoggedWhenFilterIsInactive() throws {
        var output = ""
        let logger = ActionLogger(filter: false) { output.append($0) }
        let store = Store(model: Component(), middleware: [logger])
        store.update(Action1())
        XCTAssert(output.contains("Action1"))
        store.update(Action2(property: 1))
        XCTAssert(output.contains("Action2"))
        store.update(Action3(property: 2))
        XCTAssert(output.contains("Action3"))
    }

    func testTaggedActionsAreLoggedWhenFilterIsActive() throws {
        var output = ""
        let logger = ActionLogger(filter: true) { output.append($0) }
        let store = Store(model: Component(), middleware: [logger])
        store.update(Action2(property: 1))
        XCTAssert(output.contains("Action2"))
        store.update(Action3(property: 2))
        XCTAssert(output.contains("Action3"))
    }

    func testUntaggedActionsAreNotLoggedWhenFilterIsActive() throws {
        var output = ""
        let logger = ActionLogger(filter: true) { output.append($0) }
        let store = Store(model: Component(), middleware: [logger])
        store.update(Action1())
        XCTAssertFalse(output.contains("Action1"))
    }

    func testActionPropertiesAreLogged() throws {
        var output = ""
        let logger = ActionLogger { output.append($0) }
        let store = Store(model: Component(), middleware: [logger])
        store.update(Action2(property: 1))
        XCTAssert(output.contains("property: 1"))
        store.update(Action3(property: 2))
        XCTAssert(output.contains("property: 2"))
    }

    func testRealConsoleOutput() throws {
        let store = Store(model: Component(), middleware: [ActionLogger()])
        store.update(Action1())
        store.update(Action2(property: 1))
        store.update(Action3(property: 2))
    }

    func testStopActionDisablesOutput() throws {
        var output = ""
        let logger = ActionLogger { output.append($0) }
        let store = Store(model: Component(), middleware: [logger])
        store.update(ActionLogger.Stop())
        output = ""
        store.update(Action1())
        XCTAssertEqual(output, "")
    }

    func testStartActionReenablesOutput() throws {
        var output = ""
        let logger = ActionLogger { output.append($0) }
        let store = Store(model: Component(), middleware: [logger])
        store.update(ActionLogger.Stop())
        output = ""
        store.update(ActionLogger.Start())
        store.update(Action1())
        XCTAssertNotEqual(output, "")
    }

    func testLoggerStateIsAvailable() throws {
        let store = Store(model: Component(), middleware: [ActionLogger()])
        XCTAssertNotNil(store.find(ActionLogger.Configuration.self))
    }

    func testLoggerStateIsInitiallyActive() throws {
        let store = Store(model: Component(), middleware: [ActionLogger()])
        XCTAssertTrue(try XCTUnwrap(store.find(ActionLogger.Configuration.self)).isActive)
    }

    func testLoggerStateChangesWhenStartAndStopAreDispatched() throws {
        let store = Store(model: Component(), middleware: [ActionLogger()])
        store.update(ActionLogger.Stop())
        XCTAssertFalse(try XCTUnwrap(store.find(ActionLogger.Configuration.self)).isActive)
        store.update(ActionLogger.Start())
        XCTAssertTrue(try XCTUnwrap(store.find(ActionLogger.Configuration.self)).isActive)
    }

}
