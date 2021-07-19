import SwiftUI

extension View {
    public func state(_ state: State) -> some View {
        modifier(Modifier(state: state))
    }
}

private struct Modifier: ViewModifier {
    let state: State

    func body(content: Content) -> some View {
        content.environmentObject(Store(state: state))
    }
}
