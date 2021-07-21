import SwiftUI
import Substate

/// Access states within SwiftUI views.
///
/// The `Select` helper provides access to states within SwiftUI views. Pass in a state type that
/// is part of your tree, and access its value inside the helper’s content closure.
///
/// `Select` also provides an `update` method which can be used to dispatch actions.
///
/// ```swift
/// struct CounterView: View {
///     var body: some View {
///         Select(Counter.self) { counter, update in
///             Text("Counter Value: \(counter.value)")
///             Button("Increment") { update(Counter.Increment()) }
///         }
///     }
/// }
/// ```
///
public struct Select<StateType:Substate.State, Content:View>: View {

    private let type: StateType.Type
    private let content: (StateType, @escaping (Action) -> Void) -> Content

    @EnvironmentObject private var store: Store

    /// Create a selector for a given state.
    ///
    /// - Parameters:
    ///   - type: The type of the state
    ///   - content: A closure containing a SwiftUI view which will use the state
    ///
    public init(_ type: StateType.Type, @ViewBuilder content: @escaping (StateType, @escaping (Action) -> Void) -> Content) {
        self.type = type
        self.content = content
    }

    public var body: some View {
        store.select(type).map { state in
            content(state, store.update)
        }
    }

}
