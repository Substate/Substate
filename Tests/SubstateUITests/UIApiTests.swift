import XCTest
import Substate
import SubstateUI

final class UIApiTests: XCTestCase {

    struct MyUIAction: Substate.Action {}

    func testActionTypeIsAvailable() throws {
        // MyUIAction should be able to be defined when only importing SubstateUI
    }

}
