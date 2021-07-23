import Foundation
import Runtime

public class Store: ObservableObject {

    struct InternalState: State {
        var middlewareStates: [State]
        var appState: State
        func update(action: Action) {}
    }

    // No point in this being public since underlying type isn’t available
    // Need to use select(state:), and make that more ergonomic
    // Don’t really need this to be published, can handle the single objectWillChange() call manually?
    @Published private var state: InternalState
    private let middleware: [Middleware]
    private var updateFunction: UpdateFunction!

    // TODO: Provide a publisher/AsyncSequence for easy subscription to state changes

    public init(state: State, middleware: [Middleware] = []) {
        self.state = InternalState(
            middlewareStates: middleware.compactMap { type(of: $0).state },
            appState: state
        )

        self.middleware = middleware

        self.updateFunction = self.middleware
            .reversed()
            .reduce({ action in
                self.performUpdate(action: action)
            }, { update, middleware in
                return middleware.update(store: self)(update)
            })

        self.middleware.forEach { $0.setup(store: self) }
        // TODO: Build up a list of substate type -> path segment mappings
        // Then at runtime use Mirror.descendant(a, b, c) to grab the value, rather than iterating every time
    }

    public func update(_ action: Action) {
        precondition(Thread.isMainThread, "Update must be called on the main thread!")
        updateFunction(action)
    }

    private func performUpdate(action: Action) {
        precondition(Thread.isMainThread, "Update must be called on the main thread!")
        state = reduce(state: state, action: action)
    }

    // NOTE: This will always have to be optional. But using a view helper in the same way as
    // ConnectedView, we can give child ConnectedViews a non-optional `state` property.
    // If the required state isn’t found, we could just show an empty view instead as a failure
    // mode (and log the error!)
    public func select<StateType:State>(_ type: StateType.Type) -> StateType? {
        // TODO: Don’t do this search every time, cache in init!
        find(state: type, in: self.state)
    }

    // TODO: Better naming
    public var rootState: State {
        state.appState
    }

    // TODO: Better naming
    // TODO: Optimise, bigtime!
    public var allStates: [State] {
        flatten(object: self.state).compactMap { $0 as? State }
    }

    private func find<StateType:State>(state: StateType.Type, in object: Any) -> StateType? {
        // TODO: Outrageously inefficient! Flattens every single state attribute in the tree every time!
        flatten(object: object).first(where: { $0 is StateType }) as? StateType
    }

    private func flatten(object: Any) -> [Any] {
        let mirror = Mirror(reflecting: object)
        return [object] + mirror.children.map(\.value).flatMap(flatten(object:))
    }

    /// TODO: Clean this up, remove dependency on Runtime library
    private func reduce<SomeStateType>(state: SomeStateType, action: Action) -> SomeStateType {
        // TODO: Don’t do this search every time, cache in init!
        var state = state


        // TODO: This isn’t actually recursive yet! Only recurses through `State` children.
        // TODO: Factor out this helper, it’s complex and needs its own tests.

        let mirror = Mirror(reflecting: state)
        for (index, child) in mirror.children.enumerated() {
            if let childValue = child.value as? State {

                // Try and mutate the member

                let reducedChildValue = reduce(state: childValue, action: action)

                if var state = state as? [State] {
                    // Child is a collection member; set by index
                    state[index] = reducedChildValue
                } else {
                    // Child is a property; set by mirror label
                    let info = try! typeInfo(of: type(of: state as Any))
                    let property = try! info.property(named: child.label!)
                    try! property.set(value: reducedChildValue, on: &state)
                }
            }
        }

        if var s = state as? State {
            s.update(action: action)
            if let s1 = s as? SomeStateType {
                state = s1
            }
        }

        return state
    }

}
