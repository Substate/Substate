import XCTest
import Combine
import Substate
import SubstateMiddleware

final class ActionMapperTests: XCTestCase {

    struct Action1: Action {}
    struct Action2: Action {}
    struct Action3: Action { let value: Int }
    struct Action4: Action { let value: Int; init(action: Action3) { value = action.value } }
    struct Action5: Action { let model: Model }
    struct Action6: Action { let action: Action3; let model: Model }
    struct Action7: Action { let action: Action3; let value: Int }
    struct Action8: Action { let value1: Int; let value2: Int }

    struct Model1: Model { var value = 0; func update(action: Action) {} }
    struct Model2: Model { var value = 0; func update(action: Action) {} }

    func test() throws {
        let mapper = ActionMapper {

            // Forward one empty action to another’s init
//            Action1.map(to: Action2.init)
            // Forward an empty action to a constant action
//            Action1.map(to: Action3(value: 123))
//
//            // Forward an action with a value to another’s init
//            Action3.map(to: Action4.init(action:))
//            // Forward an action with a value to another using a closure
//            Action3.map { Action4(value: $0.value) }
//
//            // Forward a model value to an action with an init
//            Action1.map(value: Model1.self, to: Action5.init(model:))
//            // Forward a model value to an action using a closure
//            Action1.map(value: Model1.self) { Action5(model: $0) }
//
//            // Forward a model’s property to an action with a matching init
//            Action1.map(value: \Model1.value, to: Action3.init(value:))
//            // Forward a model’s property to an action using a closure
//            Action1.map(value: \Model1.value) { Action3(value: $0) }
//
//            // Forward an action and a model to an action with a matching init
//            Action3.map(value: Model1.self, to: Action6.init(action:model:))
//            // Forward an action and a model to an action-returning closure
//            Action3.map(value: Model1.self) { Action4(value: $0.value + $1.value) }
//
//            // Forward an action and a model’s property to an action with matching init
//            Action3.map(value: \Model1.value, to: Action6.init(action:value:))
//            // Forward an action and a model’s property using a closure
//            Action3.map(value: \Model1.value) { Action4(value: $0.value + $1) }
//
//            // Map keypath on first action to matching init on second
//            (\Action3.value).map(to: Action4.init(value:))
//            // Map keypath on first action using closure
//            (\Action3.value).map { Action4(value: $0)
//
//            // Map keypath on an action and a whole model to another action’s matching init
//            (\Action1.value, \Model1.self).map(Action8.init(value1:value2:))
//            // Map keypaths on action and a whole model using a closure
//            (\Action1.value, \Model1.self).map { Action4(value: $0 * $1) }
//
//            // Map keypaths on action and a model to another action’s matching init
//            (\Action1.value, \Model1.value).map(Action8.init(value1:value2:))
//            // Map keypaths on action and a model using a closure
//            (\Action1.value, \Model1.value).map { Action4(value: $0 * $1) }
//
//            // Multi-arg action + model map
//            (\Action1.value, \Model1.value, \Model2.value).map(Action8.init(value1:value2:))
//            // Multi-arg action + model map via closure
//            (\Action1.value, \Model1.value, \Model2.value).map { Action4(value: $0 * $1 * $2) }





        }


        let store = Store(model: Model1(), middleware: [ActionLogger(), mapper])

        store.update(Action1())

        store.update(Action3(value: 33))



    }

}
