#if canImport(SwiftUI)

import SwiftUI

extension View {
    public func store(_ state: State, services: [Service]) -> some View {
        modifier(Modifier(state: state, services: services))
    }
}

private struct Modifier: ViewModifier {
    let state: State
    let services: [Service]

    func body(content: Content) -> some View {
        content.environmentObject(Store(state: state, services: services))
    }
}

#endif
