import Foundation

extension Notifications.Show {

    init(for task: Task, at index: Int) {
        message = "Task \(index + 1) Toggled \(task.completed ? "On" : "Off")"
    }

}
