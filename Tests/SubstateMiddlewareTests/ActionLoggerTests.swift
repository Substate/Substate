import XCTest
import Substate
import SubstateMiddleware

final class ActionLoggerTests: XCTestCase {

    struct Action1: Action {}
    struct Action2: Action, LoggableAction { let property: Int }
    struct Action3: Action, LoggableAction { let property: Int }

    struct Component: State {
        mutating func update(action: Action) {}
    }

    func testNoOutputIsProducedOnInit() throws {
        var output = ""
        let logger = ActionLogger { output.append($0) }
        _ = Store(state: Component(), middleware: [logger])
        XCTAssertEqual(output, "")
    }

    func testAllActionsAreLoggedByDefault() throws {
        var output = ""
        let logger = ActionLogger { output.append($0) }
        let store = Store(state: Component(), middleware: [logger])
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
        let store = Store(state: Component(), middleware: [logger])
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
        let store = Store(state: Component(), middleware: [logger])
        store.update(Action2(property: 1))
        XCTAssert(output.contains("Action2"))
        store.update(Action3(property: 2))
        XCTAssert(output.contains("Action3"))
    }

    func testUntaggedActionsAreNotLoggedWhenFilterIsActive() throws {
        var output = ""
        let logger = ActionLogger(filter: true) { output.append($0) }
        let store = Store(state: Component(), middleware: [logger])
        store.update(Action1())
        XCTAssertFalse(output.contains("Action1"))
    }

    func testActionPropertiesAreLogged() throws {
        var output = ""
        let logger = ActionLogger { output.append($0) }
        let store = Store(state: Component(), middleware: [logger])
        store.update(Action2(property: 1))
        XCTAssert(output.contains("property: 1"))
        store.update(Action3(property: 2))
        XCTAssert(output.contains("property: 2"))
    }

    func testRealConsoleOutput() throws {
        let store = Store(state: Component(), middleware: [ActionLogger()])
        store.update(Action1())
        store.update(Action2(property: 1))
        store.update(Action3(property: 2))
    }

}
