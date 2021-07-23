import SwiftUI
import Substate

extension View {
    public func model(_ model: Model) -> some View {
        modifier(Modifier(store: Store(model: model)))
    }
}

private struct Modifier: ViewModifier {
    let store: Store

    func body(content: Content) -> some View {
        content
            .environmentObject(store)
            .environment(\.substateStoreIsPresent, true)
    }
}

