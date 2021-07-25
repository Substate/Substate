import SwiftUI
import Substate

extension View {
    public func store(model: Substate.Model, middleware: [Middleware]) -> some View {
        modifier(Modifier(model: model, middleware: middleware))
    }
}

private struct Modifier: ViewModifier {
    let model: Substate.Model
    let middleware: [Middleware]

    func body(content: Content) -> some View {
        content
            .environmentObject(Store(model: model, middleware: middleware))
    }
}
