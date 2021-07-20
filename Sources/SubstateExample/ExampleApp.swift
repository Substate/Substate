import SwiftUI
import Substate

struct TodosApp: App {
    let store = Store(state: Root())

    var body: some Scene {
        WindowGroup {
            AppView().store(Root(), services: [])
        }
    }
}

struct AppView: View {
    var body: some View {
        Text("App View")
    }
}
