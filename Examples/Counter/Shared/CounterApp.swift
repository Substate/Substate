import SwiftUI
import SubstateUI
import SubstateMiddleware

@main struct CounterApp: App {

    var body: some Scene {
        WindowGroup {
            CounterView().store(model: Counter(), middleware: [
                /* ModelLogger(), */ ActionLogger(), ModelSaver()
            ])
        }
    }

}
