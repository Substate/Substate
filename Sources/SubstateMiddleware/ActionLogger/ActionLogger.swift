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

    public func update(update: @escaping Update, find: @escaping Find) -> (@escaping Update) -> Update {
        return { next in
            return { [self] action in
                if action is Store.Start {
                    update(Store.Register(model: ActionLogger.Configuration()))
                    update(Start())
                }

                let isActive = (find(ActionLogger.Configuration.self).first as? Configuration)?.isActive ?? true

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
