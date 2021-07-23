import SwiftUI
import SubstateUI
import SubstateMiddleware

@main struct TodosApp: App {
    var body: some Scene {
        WindowGroup {
            TodosAppView().store(state: TodosAppModel(), middleware: [ActionLogger()])
        }
    }
}
