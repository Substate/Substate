import SwiftUI
import Substate

/// Checks that a given model is available from the store in the view hierarchy before passing
/// through to the provided child content.
///
public struct ModelProvider<ModelType:Substate.State, Content:View>: View {

    let type: ModelType.Type
    let content: (ModelType) -> Content

    @EnvironmentObject private var store: Store

    public var body: some View {
        if let state = store.select(type) {
            content(state)
        } else {
            #if DEBUG
            MissingModelView(type: type)
            #endif
        }
    }
}
