import XCTest

class Tests_macOS: XCTestCase {

    let app = XCUIApplication()

    var reset: XCUIElement { app.buttons["Reset"] }
    var increment: XCUIElement { app.buttons["Increment"] }
    var decrement: XCUIElement { app.buttons["Decrement"] }

    var counter: XCUIElement { app.staticTexts.firstMatch }

    func testCounter() throws {
        app.launch()
        XCTAssertEqual(counter.value as! String, "0")

        increment.tap()
        XCTAssertEqual(counter.value as! String, "1")

        reset.tap()
        XCTAssertEqual(counter.value as! String, "0")

        decrement.tap()
        XCTAssertEqual(counter.value as! String, "-1")

        reset.tap()
        XCTAssertEqual(counter.value as! String, "0")
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
