import SwiftUI
import SubstateUI
import SubstateMiddleware

@main struct TodosApp: App {

    let player = SoundPlayer()
    let publisher = ActionPublisher()

    var body: some Scene {
        WindowGroup {
            TodosAppView()
                .store(model: TodosAppModel(), middleware: [
                    ActionLogger(),
                    ActionTrigger(sources: appTriggers),
                    ActionFunneller(funnels: taskToggledFunnel, threeTasksCreatedFunnel, taskDeletedFunnel),
                    ActionFollower(),
                    ActionDelayer(),
                    publisher,
                    ModelSaver(configuration: .init(saveStrategy: .manual)),
                    Inspector()
                ])
                .onReceive(publisher.publisher(for: Sound.Play.self)) { action in
                    player.play(action.sound)
                }
        }
    }
}
