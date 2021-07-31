import Foundation
import Substate

public typealias MappedAction = (Action) -> Action?


extension Action {
    // Forward one empty action to another’s init
    // Action1.map(to: Action2.init)
    public static func map<A2>(to output: @escaping () -> A2) -> MappedAction where A2: Action {
        return { action in
            return action is Self ? output() : nil
        }
    }

    // Forward an empty action to a constant action
    // Action1.map(to: Action3(value: 123))
    public static func map<A2>(to output: A2) -> MappedAction where A2: Action {
        return { action in
            return action is Self ? output : nil
        }
    }

    // Forward an action with a value to another’s init
    // Action3.map(to: Action4.init(value:))
    public static func map<A2>(to output: @escaping (Self) -> A2) -> MappedAction where A2: Action {
        return { action in
            if let action = action as? Self {
                return output(action)
            } else {
                return nil
            }
        }
    }

    // Forward an action with a value to another using a closure
    // Action3.map { Action4(value: $0.value) }
//     Do this one, then can use it in todo app


}



public class ActionMapper: Middleware {

    var mappedActions: [MappedAction]

    // MARK: - Initialisation

    public init(@MappedActionList _ list: () -> [MappedAction]) {
        mappedActions = list()
    }

    // MARK: - Result Builder DSL


    @resultBuilder
    public struct MappedActionList {
        public static func buildBlock(_ maps: MappedAction...) -> [MappedAction] {
            maps
        }
    }

    // MARK: - Middleware API

    public var model: Model?

    public func setup(store: Store) {

    }

    public func update(store: Store) -> (@escaping Update) -> Update {
        return { next in
            return { action in
                next(action)
                self.mappedActions.forEach { ma in
                    if let newAction = ma(action) {
                        store.update(newAction)
                    }
                }
            }
        }
    }

}
