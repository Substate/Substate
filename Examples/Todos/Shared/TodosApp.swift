import SwiftUI
import Substate
import SubstateUI
import SubstateMiddleware

let publisher = ActionPublisher()

let store = Store(model: TodosAppModel.example, middleware: [
    ActionLogger(), publisher, Inspector()
])

@main struct TodosApp: App {
    var body: some Scene {
        WindowGroup {
            TodosAppView()
                .environmentObject(store)
                .onReceive(publisher.publisher(for: ToolbarViewModel.AddWasCommitted.self)) { add in
                    store.update(TaskList.Create(body: add.body))
                }
                .onAppear { test() }
        }
    }
}
