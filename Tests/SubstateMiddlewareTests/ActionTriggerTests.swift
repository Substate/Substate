import XCTest
import Combine
import Substate
import SubstateMiddleware

final class ActionTriggerTests: XCTestCase {

    struct Action1: Action {}
    struct Action2: Action { let value: Int }
    struct Action3: Action { let Model: Model1 }

    struct Model1: Model { var value = 1; func update(action: Action) {} }
    struct Model2: Model { var value = 2; func update(action: Action) {} }
    struct Model3: Model { var value = 3; func update(action: Action) {} }

#if compiler(>=5.4)
    /// Check every intended version of `Action.trigger`/`Action.map` compiles.
    ///
    func testTriggerMethod() throws {
        _ = ActionTriggerList {

            Action1.trigger(Action1())

            Action2.trigger { Action1() }
            Action2.trigger { _ in Action1() }

            Action2.map(\.value).trigger(Action2.init(value:))
//            Action2.map(\.value, \.value) { _, _ in Action1() }
//            Action2.map(\.value, \.value, \.value) { _, _, _ in Action1() }
//
            Action1.map(Model1.self).trigger(Action3.init)
//            Action1.map(Model1.self, Model2.self) { _, _ in Action1() }
//            Action1.map(Model1.self, Model2.self, Model3.self) { _, _, _ in Action1() }
//
            Action1.map(\Model1.value).trigger(Action2.init(value:))
//            Action1.map(\Model1.value, \Model2.value) { _, _ in Action1() }
//            Action1.map(\Model1.value, \Model2.value, \Model3.value) { _, _, _ in Action1() }
//
//            Action2.map(\.value, Model1.self) { _, _ in Action1() }
//            Action2.map(\.value, Model1.self, Model2.self) { _, _, _ in Action1()  }
//
            Action2.map(\.value, \Model1.value).trigger { _, _ in Action1() }
//            Action2.map(\.value, \Model1.value, \Model2.value) { _, _, _ in Action1()  }
        }
    }
#endif

    // TODO: Test the actual operation of ActionTrigger
    // TODO: Will need an ActionRecorder or similar to check all the results

}
