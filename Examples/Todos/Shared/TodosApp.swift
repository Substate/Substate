import SwiftUI
import SubstateUI
import SubstateMiddleware

@main struct TodosApp: App {
    var body: some Scene {
        WindowGroup {
            TodosAppView().store(model: TodosAppModel.example, middleware: [ActionLogger()])
        }
    }
}
