import SwiftUI
import Substate

extension Substate.Action {
    public func map<Content:View>(@ViewBuilder content: @escaping (@escaping () -> Void) -> Content) -> some View {
        StoreProvider { store in
            content({ store.update(self) })
        }
    }
}
