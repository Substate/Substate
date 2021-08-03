import Substate

/// Log actions to the standard output.
///
public class ActionLogger: Middleware {

    private let filter: Bool
    private let output: (String) -> Void
    private let tag = "Substate.Action"

    public init(filter: Bool = false, output: @escaping (String) -> Void = output) {
        self.filter = filter
        self.output = output
    }

    public let model: Substate.Model? = ActionLogger.Configuration()

    public func setup(store: Store) {
        store.update(Start())
    }

    public func update(store: Store) -> (@escaping Update) -> Update {
        return { next in
            return { [self] action in
                let isActive = store.find(ActionLogger.Configuration.self)?.isActive ?? false

                if isActive && (!filter || (filter && action is LoggedAction)) {
                    output(format(action: action))
                }

                next(action)
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
