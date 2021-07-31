import Substate

public typealias MappedAction = (Action) -> Action?


extension Action {
    public static func map<A2>(to output: @escaping () -> A2) -> MappedAction where A2: Action {
        return { action in
            return action is Self ? output() : nil
        }
    }
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
            }
        }
    }

}
