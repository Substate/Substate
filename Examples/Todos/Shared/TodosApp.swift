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
        appStream,
        ActionFollower(),
        ActionDelayer(),
        ModelSaver(configuration: .init(saveStrategy: .manual))
    ]}

}

// Ignore some sendable warnings that are _probably_ fine given this is just a demo app.

extension UUID: @unchecked Sendable {}
extension Date: @unchecked Sendable {}
