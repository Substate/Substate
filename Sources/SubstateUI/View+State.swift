import SwiftUI
import Substate

extension View {
    public func state(_ state: Substate.State) -> some View {
        modifier(Modifier(state: state))
    }
}

private struct Modifier: ViewModifier {
    let state: Substate.State

    func body(content: Content) -> some View {
        content.environmentObject(Store(state: state))
    }
}

