import XCTest
import Substate
import SubstateUI

final class ModelTests: XCTestCase {

    typealias Model = SubstateUI.Model

    struct Settings: Substate.Model {
        var value = true
        struct Reset: Action {}
        struct Update: Action { let settings: Settings }
        struct UpdateValue: Action { let value: Bool }
        func update(action: Action) {}
    }

    func testModelInterface() throws {

        @Model var settings: Settings
        @Model(Settings.Update.init) var settings2: Settings

        // How do we provide this keypath functionality without introducing the 'Value' type?

        // ?
        // @Value<Settings> var settings
        // @Value(Settings.self) var settings

        @Value(\Settings.value) var value
        @Value(\Settings.value) var value2: Bool

        @Value(\Settings.value, Settings.UpdateValue.init) var value3
        @Value(\Settings.value, Settings.UpdateValue.init) var value4: Bool

    }

    @Dispatch(Settings.Reset()) var reset
    @Dispatch(Settings.UpdateValue(value: true)) var update

    func testActionInterface() throws {
         // reset()
         // update()
    }

}
