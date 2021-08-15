import XCTest
import Substate
import SubstateMiddleware

final class ModelLoggerTests: XCTestCase {

    /// TODO: Test whether sub-states have been logged as part of a parent, or individually.

    struct Action1: Action {}

    struct Component1: Model {
        var property = 123
        var component2 = Component2()
        var component3 = Component3()
        mutating func update(action: Action) {}
    }

    struct Component2: Model, LoggedModel {
        var property = 456
        mutating func update(action: Action) {}
    }

    struct Component3: Model, LoggedModel {
        mutating func update(action: Action) {}
    }

    func testRootStateIsLoggedOnInitByDefault() throws {
        var output = ""
        let logger = ModelLogger { output.append($0) }
        _ = Store(model: Component1(), middleware: [logger])
        XCTAssert(output.contains("Component1"))
    }

    func testRootStateIsNotLoggedOnInitWhenFilterIsActive() throws {
        var output = ""
        let logger = ModelLogger(filter: true) { output.append($0) }
        _ = Store(model: Component1(), middleware: [logger])
        XCTAssertFalse(output.contains("Component1"))
    }

    func testTaggedStatesAreLoggedOnInitWhenFilterIsActive() throws {
        var output = ""
        let logger = ModelLogger(filter: true) { output.append($0) }
        _ = Store(model: Component1(), middleware: [logger])
        XCTAssert(output.contains("Component2"))
        XCTAssert(output.contains("Component3"))
    }

    func testRootStateIsLoggedByDefault() throws {
        var output = ""
        let logger = ModelLogger { output.append($0) }
        let store = Store(model: Component1(), middleware: [logger])
        store.send(Action1())
        XCTAssert(output.contains("Component1"))
    }

    func testRootStateIsLoggedWhenFilterIsInactive() throws {
        var output = ""
        let logger = ModelLogger(filter: false) { output.append($0) }
        let store = Store(model: Component1(), middleware: [logger])
        store.send(Action1())
        XCTAssert(output.contains("Component1"))
    }

    func testTaggedStatesAreLoggedWhenFilterIsActive() throws {
        var output = ""
        let logger = ModelLogger(filter: true) { output.append($0) }
        let store = Store(model: Component1(), middleware: [logger])
        store.send(Action1())
        XCTAssert(output.contains("Component2"))
        XCTAssert(output.contains("Component3"))
    }

    func testUntaggedStateIsNotLoggedWhenFilterIsActive() throws {
        var output = ""
        let logger = ModelLogger(filter: true) { output.append($0) }
        let store = Store(model: Component1(), middleware: [logger])
        store.send(Action1())
        XCTAssertFalse(output.contains("Component1"))
    }

    func testPropertiesAreLogged() throws {
        var output = ""
        let logger = ModelLogger { output.append($0) }
        let store = Store(model: Component1(), middleware: [logger])
        store.send(Action1())
        XCTAssert(output.contains("property: 123"))
    }

    func testRealConsoleOutput() throws {
        let store = Store(model: Component1(), middleware: [ModelLogger()])
        store.send(Action1())
    }

    func testStoreInternalStateIsNotLeaked() throws {
        var output = ""
        let logger = ModelLogger { output.append($0) }
        _ = Store(model: Component1(), middleware: [logger])
        XCTAssertFalse(output.contains("InternalState"))
    }

}
