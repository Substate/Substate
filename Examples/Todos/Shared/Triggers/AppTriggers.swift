import Substate
import SubstateMiddleware

let appTriggers = ActionTriggerList {

    soundTriggers
    notificationTriggers
    saveTriggers

    // Titlebar

    ModelSaver.UpdateDidComplete
        .map(\Tasks.all.count)
        .trigger(Titlebar.UpdateCount.init)

    Tasks.Changed
        .map(\Tasks.all.count)
        .trigger(Titlebar.UpdateCount.init)

    // Toolbar

    Toolbar.SaveButtonWasPressed
        .trigger(Toolbar.Reset())

    Toolbar.SaveButtonWasPressed
        .map(\Toolbar.newTaskBody)
        .trigger(Tasks.Create.init(body:))

    Tasks.Toggle
        .map(\.id, \Tasks.all)
        .trigger { id, tasks -> Notifications.Show? in
            if let index = tasks.firstIndex(where: { $0.id == id }) {
                return Notifications.Show(for: tasks[index], at: index)
            } else {
                return nil
            }
        }

}
