import Substate

public class StateLogger: Middleware {

    private let filter: Bool
    private let output: (String) -> Void
    private let tag = "Substate.State"

    public init(filter: Bool = false, output: @escaping (String) -> Void = output) {
        self.filter = filter
        self.output = output
    }

    public static let initialInternalState: Substate.State? = nil

    public func setup(store: Store) {
        fire(store: store)
    }

    public func update(store: Store) -> (@escaping UpdateFunction) -> UpdateFunction {
        return { next in
            return { [self] action in
                fire(store: store)
                next(action)
            }
        }
    }

    private func fire(store: Store) {
        if filter {
            store.allStates
                .filter { $0 is LoggedState }
                .forEach { output(format(state: $0)) }
        } else {
            output(format(state: store.rootState))
        }

    }

    private func format(state: State) -> String {
        var string = ""
        dump(state, to: &string, name: tag)
        return string.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public static func output(message: String) {
        print(message)
    }

}
