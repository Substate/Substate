import SwiftUI
import SubstateUI

struct TodosApp: App {
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
