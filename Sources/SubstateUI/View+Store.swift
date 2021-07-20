import SwiftUI
import Substate

extension View {
    public func store(_ state: Substate.State, services: [Service]) -> some View {
        modifier(Modifier(state: state, services: services))
    }
}

private struct Modifier: ViewModifier {
    let state: Substate.State
    let services: [Service]

    func body(content: Content) -> some View {
        content.environmentObject(Store(state: state, services: services))
    }
}
