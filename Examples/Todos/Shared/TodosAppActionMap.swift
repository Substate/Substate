import Substate
import SubstateMiddleware
import Foundation

let appActionMap = ActionMap {

    // Titlebar

    TaskList.Changed
        .map(\TaskList.all.count, to: Titlebar.UpdateCount.init)

    ModelSaver.UpdateDidComplete
        .map(\TaskList.all.count, to: Titlebar.UpdateCount.init)

    // Toolbar

    Toolbar.SaveButtonWasPressed
        .map(to: Toolbar.Reset())

    Toolbar.SaveButtonWasPressed
        .map(\Toolbar.newTaskBody) { $0.map { TaskList.Create(body: $0) } }

    // Sound effects

    TaskList.Create
        .map(to: SoundEffects.Play(.blip))

    TaskList.Delete
        .map(to: SoundEffects.Play(.trash))

    // Notifications

    TaskList.Create
        .map(to: Notifications.Show(message: "Task Created"))

    TaskList.Delete
        .map(to: Notifications.Show(message: "Task Deleted"))

//    TaskList.Toggle
//        .map(to: Notifications.Show(message: "Task State Toggled"))

    TaskList.Toggle
        .map(\.id, \TaskList.all) { id, tasks -> Notifications.Show? in
            // Cool bit of additional functionality, but where should this live ideally?
            // The map here should remain pretty minimal as just a list of simple mappings.
            if let index = tasks.firstIndex(where: { $0.id == id }) {
                let state = tasks[index].completed
                return Notifications.Show(message: "Task \(index + 1) Toggled \(state ? "On" : "Off")")
            } else {
                return nil
            }
        }


    ModelSaver.LoadDidSucceed
        .map(to: Notifications.Show(message: "All Tasks Loaded"))

}
