import SwiftUI
import Substate

public struct Container<StateType:Substate.State, Content:View>: View {

    private let substate: StateType.Type
    private let content: (StateType, @escaping (Action) -> Void) -> Content

    @EnvironmentObject private var store: Store

    public init(_ substate: StateType.Type, @ViewBuilder content: @escaping (StateType, @escaping (Action) -> Void) -> Content) {
        self.substate = substate
        self.content = content
    }

    public var body: some View {
        store.state(substate).map { state in
            content(state, store.send)
        }
    }

}
