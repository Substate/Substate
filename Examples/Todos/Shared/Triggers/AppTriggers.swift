import Substate
import SubstateMiddleware
import Foundation

@MainActor let appTriggers = ActionTriggers {

    soundTriggers
    notificationTriggers
    saveTriggers

    // Titlebar

    ModelSaver.LoadDidComplete
        .replace(with: \Tasks.all.count)
        .trigger { Titlebar.UpdateCount(count: $0) }

    Tasks.Changed
        .replace(with: \Tasks.all.count)
        .trigger { Titlebar.UpdateCount(count: $0) }

    // Toolbar

    Toolbar.SaveButtonWasPressed
        .trigger(Toolbar.Reset())

    Toolbar.SaveButtonWasPressed
        .replace(with: \Toolbar.newTaskBody)
        .trigger { Tasks.Create.init(body: $0) }

    Tasks.Toggle
        .map(\.id)
        .combine(with: \Tasks.all)
        .trigger { id, tasks -> Notifications.Show? in
            if let index = tasks.firstIndex(where: { $0.id == id }) {
                return Notifications.Show(for: tasks[index], at: index)
            } else {
                return nil
            }
        }

}
