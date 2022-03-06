import SwiftUI
import SubstateUI
import SubstateMiddleware

@main struct TodosApp: App {

    var body: some Scene {
        WindowGroup {
            TodosAppView()
                .store(model: TodosAppModel(), middleware: middleware)
        }
    }

    var middleware: [Middleware] {[
        ActionLogger(),
        appTriggers,
        // ActionFunneller(funnels: taskToggledFunnel, threeTasksCreatedFunnel, taskDeletedFunnel),
        ActionFollower(),
        ActionDelayer(),
        ModelSaver(configuration: .init(saveStrategy: .manual))
    ]}

}
