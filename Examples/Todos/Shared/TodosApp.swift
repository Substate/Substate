import SwiftUI
import SubstateUI
import SubstateMiddleware

@main struct TodosApp: App {
    var body: some Scene {
        WindowGroup {
            TodosAppView()
                .store(model: TodosAppModel(), middleware: [
                    ActionLogger(),
                    ActionMapper(map: appActionMap),
                    ActionFollower(),
                    ActionDelayer(),
                    ModelSaver(),
                    Inspector()
                ])
        }
    }
}
