import Substate
import SubstateMiddleware

let appTriggers = ActionTriggers {

    soundTriggers
    notificationTriggers
    saveTriggers

    // Titlebar

    ModelSaver.UpdateDidComplete
        .replace(with: \Tasks.all.count)
        .trigger(Titlebar.UpdateCount.init)

    Tasks.Changed
        .replace(with: \Tasks.all.count)
        .trigger(Titlebar.UpdateCount.init)

    // Toolbar

    Toolbar.SaveButtonWasPressed
        .trigger(Toolbar.Reset())

    Toolbar.SaveButtonWasPressed
        .replace(with: \Toolbar.newTaskBody)
        .trigger(Tasks.Create.init(body:))

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
