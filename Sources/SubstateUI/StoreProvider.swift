import SwiftUI
import Substate

/// Checks that a store is present in the view hierarchy before passing through to the provided
/// child content. 'Store present' is checked using the environment value we manually set in the
/// `state()` and `store()` view modifiers.
///
struct StoreProvider<Content:View>: View {

    let content: (Store) -> Content

    @Environment(\.substateStoreIsPresent) private var substateStoreIsPresent: Bool

    var body: some View {
        if substateStoreIsPresent {
            Wrapper(content: content)
        } else {
            #if DEBUG
            MissingStoreView()
            #endif
        }
    }

    private struct Wrapper: View {

        let content: (Store) -> Content

        @EnvironmentObject var store: Store

        var body: some View {
            content(store)
        }

    }

}
