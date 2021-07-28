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

    public let model: Model? = nil

    public func setup(store: Store) {
        fire(store: store)
    }

    public func update(store: Store) -> (@escaping Update) -> Update {
        return { next in
            return { [self] action in
                next(action)
                fire(store: store)
            }
        }
    }

    private func fire(store: Store) {
        if filter {
            store.allModels
                .filter { $0 is LoggedModel }
                .forEach { output(format(model: $0)) }
        } else {
            output(format(model: store.rootModel))
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
