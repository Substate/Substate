import SubstateMiddleware

@MainActor let notificationTriggers = ActionTriggers {

    Tasks.Create.trigger(Notifications.Show(message: .taskCreated))
    Tasks.Delete.trigger(Notifications.Show(message: .taskDeleted))

    ModelSaver.LoadDidSucceed.trigger(Notifications.Show(message: "Tasks loaded from disk"))
    // Load/Save of tasks only? May be able to preserve type info on this one and provide a
    // nice generic ModelSaver.SaveDidSucceed<Tasks> / ModelSaver.SaveAllDidSucceed
    // ModelSaver.SaveDidSucceed.trigger(Notifications.Show(message: "Tasks saved to disk"))

    Notifications.Changed
        .replace(with: \Notifications.notifications.count)
        .trigger { $0 > 0 ? Notifications.DismissAfterDelay() : nil }

}
