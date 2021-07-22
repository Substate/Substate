import SwiftUI
import SubstateUI
import SubstateMiddleware

@main struct CounterApp: App {

    var body: some Scene {
        WindowGroup {
            CounterView().store(state: Counter(), middleware: [StateLogger(), ActionLogger()])
        }
    }

}
