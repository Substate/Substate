import Substate

/// Log models to the standard output after updates.
///
public class ModelLogger: Middleware {

    private let filter: Bool
    private let output: (String) -> Void
    private let tag = "Substate.Model"

    public init(filter: Bool = false, output: @escaping (String) -> Void = output) {
        self.filter = filter
        self.output = output
    }

    public func configure(store: Store) -> (@escaping DispatchFunction) -> DispatchFunction {
        { next in
            { [self] action in
                try await next(action)
                fire(find: store.uncheckedFind)
            }
        }
    }

    /// TODO: This isn’t great behaviour for the non-filter case. We used to have access to the root
    /// model, but now that’s gone from the middleware API. What to do?
    /// TODO: We now have full access to the store, so we can refactor this default behaviour.
    @MainActor private func fire(find: Find) {
        if filter {
            find(nil)
                .filter { $0 is LoggedModel }
                .forEach { output(format(model: $0)) }
        } else {
            find(nil)
                .forEach { output(format(model: $0)) }
        }

    }

    private func format(model: Model) -> String {
        var string = ""
        dump(model, to: &string, name: tag)
        return string.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public static func output(message: String) {
        print(message)
    }

}
