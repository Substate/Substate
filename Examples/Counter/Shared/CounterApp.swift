import SwiftUI
import SubstateUI
import SubstateMiddleware

@main struct CounterApp: App {

    var body: some Scene {
        WindowGroup {
            CounterView().store(model: Counter(), middleware: middleware)
        }
    }

    var middleware: [Middleware] {[
        // ModelLogger(),
        ActionLogger(),
        ModelSaver()
        // Inspector()
    ]}

}
