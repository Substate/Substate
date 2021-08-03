import Substate
import SubstateMiddleware

let appTriggers = ActionTriggerList {

    // Sounds

    Store.Start
        .trigger(Sound.Play(.blip))

    Tasks.Create
        .trigger(Sound.Play(.blip))

    Tasks.Delete
        .trigger(Sound.Play(.trash))

    // Notifications

    Tasks.Create
        .trigger(Notifications.Show(message: .taskCreated))

    Tasks.Delete
        .trigger(Notifications.Show(message: .taskDeleted))

    // Milestones

    Milestones.TaskToggled
        .trigger(Notifications.Show(message: "You toggled your first task!"))

    Milestones.ThreeTasksCreated
        .trigger(Notifications.Show(message: "You created three tasks!"))

    Milestones.TaskDeleted
        .trigger(Notifications.Show(message: "You deleted your first task!"))

    // Load & Save

    Tasks.Changed
        .trigger(ModelSaver.Save(Tasks.self))

    ModelSaver.LoadDidSucceed
        .trigger(Notifications.Show(message: "Tasks loaded from disk"))

    ModelSaver.UpdateDidComplete
        .map(\Tasks.all.count)
        .trigger(Titlebar.UpdateCount.init)

    // Titlebar

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
