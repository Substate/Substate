import XCTest
import Substate
import SubstateUI

final class ModelTests: XCTestCase {

    typealias Model = SubstateUI.Model

    struct Settings: Substate.Model {
        var value = true
        struct Update: Action { let settings: Settings }
        struct UpdateValue: Action { let value: Bool }
        func update(action: Action) {}
    }

    func testModelInterface() throws {

        @Model var settings: Settings
        @Model(Settings.Update.init) var settings2: Settings

        // How do we provide this keypath functionality without introducing the 'Value' type?

        @Value(\Settings.value) var value: Bool
        @Value(\Settings.value, Settings.UpdateValue.init) var value2: Bool

    }

}
