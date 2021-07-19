import Foundation
import Runtime

public class Store: ObservableObject {

    // No point in this being public since underlying type isn’t available
    // Need to use select(state:), and make that more ergonomic
    // Don’t really need this to be published, can handle the single objectWillChange() call manually?
    @Published private var state: State
    private var services: [Service]

    // TODO: Provide a publisher/AsyncSequence for easy subscription to state changes

    public init(state: State, services: [Service] = []) {
        self.state = state
        self.services = services

        // TODO: Build up a list of substate type -> path segment mappings
        // Then at runtime use Mirror.descendant(a, b, c) to grab the value, rather than iterating every time
    }

    public func send(_ action: Action) {
        precondition(Thread.isMainThread, "Actions must be dispatched on the main thread!")
        dump(action)
        state = reduce(state: state, action: action)
    }

    // NOTE: This will always have to be optional. But using a view helper in the same way as
    // ConnectedView, we can give child ConnectedViews a non-optional `state` property.
    // If the required state isn’t found, we could just show an empty view instead as a failure
    // mode (and log the error!)
    public func state<StateType:State>(_ type: StateType.Type) -> StateType? {
        // TODO: Don’t do this search every time, cache in init!
        find(state: type, in: self.state)
    }

    private func find<StateType:State>(state: StateType.Type, in object: Any) -> StateType? {
        // TODO: Outrageously inefficient! Flattens every single state attribute in the tree every time!
        flatten(object: object).first(where: { $0 is StateType }) as? StateType
    }

    private func flatten(object: Any) -> [Any] {
        let mirror = Mirror(reflecting: object)
        return [object] + mirror.children.map(\.value)
    }

    /// TODO: Clean this up, remove dependency on Runtime library
    private func reduce<SomeStateType>(state: SomeStateType, action: Action) -> SomeStateType {
        // TODO: Don’t do this search every time, cache in init!
        var state = state

        if var s = state as? State {
            s.update(action: action)
            if let s1 = s as? SomeStateType {
                state = s1
            }
        }

        let mirror = Mirror(reflecting: state)
        for child in mirror.children {
            if let childValue = child.value as? State {

                // Try and mutate the member

                let reducedChildValue = reduce(state: childValue, action: action)

                let info = try! typeInfo(of: type(of: state as Any))
                let property = try! info.property(named: child.label!)
                try! property.set(value: reducedChildValue, on: &state)

            }
        }

        return state
    }

}
