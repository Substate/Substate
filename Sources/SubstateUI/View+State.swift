import SwiftUI
import Substate

extension View {
    public func state(_ state: Substate.State) -> some View {
        modifier(Modifier(store: Store(state: state)))
    }
}

private struct Modifier: ViewModifier {
    let store: Substate.Store

    func body(content: Content) -> some View {
        content
            .environmentObject(store)
            .environment(\.substateStoreIsPresent, true)
    }
}

