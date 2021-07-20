import SwiftUI
import Substate

public struct Select<StateType:Substate.State, Content:View>: View {

    private let type: StateType.Type
    private let content: (StateType, @escaping (Action) -> Void) -> Content

    @EnvironmentObject private var store: Store

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
