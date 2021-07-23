import SwiftUI
import Substate

extension Model {

    // Model.map { model in ... }
    public static func map<Content:View>(@ViewBuilder _ content: @escaping (Self) -> Content) -> some View {
        StoreProvider { _ in
            ModelProvider(type: Self.self) { model in
                content(model)
            }
        }
    }

    // Model.map { model, update in ... Button("") { update(MyAction()) } }
    public static func map<Content:View>(@ViewBuilder _ content: @escaping (Self, @escaping (Action) -> Void) -> Content) -> some View {
        StoreProvider { store in
            ModelProvider(type: Self.self) { model in
                content(model, store.update)
            }
        }
    }

//    // Model.map { model, update in ... Button("", action: update(MyAction()) }
//    public static func map<Content:View>(@ViewBuilder _ content: @escaping (Self, @escaping (Action) -> () -> Void) -> Content) -> some View {
//        StoreProvider { store in
//            ModelProvider(type: Self.self) { model in
//                content(model, { action in { store.update(action) } })
//            }
//        }
//    }

}
