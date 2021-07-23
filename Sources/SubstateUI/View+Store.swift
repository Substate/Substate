import SwiftUI
import Substate

extension View {
    public func store(state: Substate.State, middleware: [Middleware]) -> some View {
        modifier(Modifier(state: state, middleware: middleware))
    }
}

private struct Modifier: ViewModifier {
    let state: Substate.State
    let middleware: [Middleware]

    func body(content: Content) -> some View {
        content
            .environmentObject(Store(state: state, middleware: middleware))
            .environment(\.substateStoreIsPresent, true)
    }
}
