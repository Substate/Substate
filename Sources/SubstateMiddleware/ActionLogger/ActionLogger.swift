import os.log
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

    public func configure(store: Store) -> (@escaping DispatchFunction) -> DispatchFunction {
        { next in
            { [self] action in
                let isActive = store.find(ActionLogger.Configuration.self)?.isActive ?? true
                let shouldLogAction = isActive && (!filter || (filter && action is LoggedAction))

                if shouldLogAction {
                    output(format(action: action))
                }

                if action is Store.Start {
                    try await store.dispatch(Store.Register(model: ActionLogger.Configuration()))
                    try await store.dispatch(Start())
                }

                try await next(action)
            }
        }
    }

    private func format(action: Action) -> String {
        var string = ""
        dump(action, to: &string, name: tag)
        return string.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public static func output(message: String) {
        logger.debug("\(message, privacy: .public)")
    }

    private  static let logger = Logger(subsystem: "Substate", category: "ActionLogger")

}
