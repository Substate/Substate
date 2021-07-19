import SwiftUI

public struct Container<Substate:State, Content:View>: View {

    private let substate: Substate.Type
    private let content: (Substate, @escaping (Action) -> Void) -> Content

    @EnvironmentObject private var store: Store

    public init(_ substate: Substate.Type, @ViewBuilder content: @escaping (Substate, @escaping (Action) -> Void) -> Content) {
        self.substate = substate
        self.content = content
    }

    public var body: some View {
        store.state(substate).map { state in
            content(state, store.send)
        }
    }

}
