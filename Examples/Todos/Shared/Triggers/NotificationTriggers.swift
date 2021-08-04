import SubstateMiddleware

let notificationTriggers = ActionTriggerList {

    Tasks.Create
        .trigger(Notifications.Show(message: .taskCreated))

    Tasks.Delete
        .trigger(Notifications.Show(message: .taskDeleted))

    Milestones.TaskToggled
        .trigger(Notifications.Show(message: "You toggled your first task!"))

    Milestones.ThreeTasksCreated
        .trigger(Notifications.Show(message: "You created three tasks!"))

    Milestones.TaskDeleted
        .trigger(Notifications.Show(message: "You deleted your first task!"))

    ModelSaver.LoadDidSucceed
        .trigger(Notifications.Show(message: "Tasks loaded from disk"))

    ModelSaver.SaveDidSucceed
        .trigger(Notifications.Show(message: "Tasks saved to disk"))

}
