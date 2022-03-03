import SwiftUI
import Substate

extension View {
    /// Provide a Substate model to the upstream view hierarchy.
    ///
    @MainActor public func model(_ model: Substate.Model) -> some View {
        modifier(Modifier(store: Store(model: model)))
    }
}

private struct Modifier: ViewModifier {
    let store: Store

    func body(content: Content) -> some View {
        content.environmentObject(store)
    }
}
