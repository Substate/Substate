import Substate
import SubstateMiddleware

import SwiftUI
import SubstateUI

let player = SoundPlayer()
let publisher = ActionPublisher()

let store = Store(model: TodosAppModel(), middleware: [
    ActionLogger(),
    appTriggers,
    ActionFunneller(funnels: taskToggledFunnel, threeTasksCreatedFunnel, taskDeletedFunnel),
    ActionFollower(),
    ActionDelayer(),
    publisher,
    ModelSaver(configuration: .init(saveStrategy: .manual)),
    // Inspector()
])

@main struct TodosApp: App {

    var body: some Scene {
        WindowGroup {
            TodosAppView()
                .environmentObject(store)
                .onReceive(publisher.publisher(for: Sound.Play.self)) { action in
                    // TODO: Cleaner way to set this. Another publisher to catch it?
                    if store.find(Settings.self)?.sounds ?? false {
                        player.play(action.sound)
                    }
                }
        }
    }

}
