import SwiftUI
import SubstateUI
import SubstateMiddleware

@main struct TodosApp: App {
    var body: some Scene {
        WindowGroup {
            ListView().store(state: TodosAppModel(), middleware: [ActionLogger()])
        }
    }
}
