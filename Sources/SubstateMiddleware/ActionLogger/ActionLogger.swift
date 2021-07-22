import Substate

public class ActionLogger: Middleware {

    private let filter: Bool
    private let output: (String) -> Void
    private let tag = "Substate.Action"

    public init(filter: Bool = false, output: @escaping (String) -> Void = output) {
        self.filter = filter
        self.output = output
    }

    public static let state: Substate.State? = ActionLogger.State()

    public func setup(store: Store) {
        store.update(Start())
    }

    public func update(store: Store) -> (@escaping UpdateFunction) -> UpdateFunction {
        return { next in
            return { [self] action in
                next(action)

                let isActive = store.select(ActionLogger.State.self)?.isActive ?? false

                if isActive && (!filter || (filter && action is LoggedAction)) {
                    output(format(action: action))
                }
            }
        }
    }

    private func format(action: Action) -> String {
        var string = ""
        dump(action, to: &string, name: tag)
        return string.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public static func output(message: String) {
        print(message)
    }

}
