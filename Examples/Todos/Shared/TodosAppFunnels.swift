import Substate
import SubstateMiddleware

enum Milestones {
    struct TaskToggled: Action {}
    struct TaskDeleted: Action {}
    struct ThreeTasksCreated: Action {}
}

let taskToggledFunnel = ActionFunnel(for: Milestones.TaskToggled()) {
    Tasks.Toggle.occurred()
}

let threeTasksCreatedFunnel = ActionFunnel(for: Milestones.ThreeTasksCreated()) {
    Tasks.Create.occurred()
    Tasks.Create.occurred()
    Tasks.Create.occurred()
}

let taskDeletedFunnel = ActionFunnel(for: Milestones.TaskDeleted()) {
    Tasks.Delete.occurred()
}
