import XCTest

class Tests_iOS: XCTestCase {

    let app = XCUIApplication()

    var reset: XCUIElement { app.buttons["Reset"] }
    var increment: XCUIElement { app.buttons["Increment"] }
    var decrement: XCUIElement { app.buttons["Decrement"] }

    var counter: XCUIElement { app.staticTexts.firstMatch }

    func testCounter() throws {
        app.launch()
        XCTAssertEqual(counter.label, "0")

        increment.tap()
        XCTAssertEqual(counter.label, "1")

        reset.tap()
        XCTAssertEqual(counter.label, "0")

        decrement.tap()
        XCTAssertEqual(counter.label, "-1")

        reset.tap()
        XCTAssertEqual(counter.label, "0")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }

}
