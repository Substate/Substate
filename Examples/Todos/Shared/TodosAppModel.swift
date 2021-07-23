import Foundation
import Substate


struct TodosAppModel: Model {

    var taskList = TaskList()

    // naming?
    // I think this is good, having small separate non-view-related state stores for these items.
//    var sortState = SortState()
//    var searchState = SearchState()

    // How are we going to get the task list data to view-model pairs that need it?
    // Just have parents update children by inspection and copying?

    // AppState could inspect listViewModel settings (sort column, sort order, paging, etc), and copy an ordered sublist of tasks from the taskList storage.
    // That’s not all that bad?


    // Or just have VMs provide functions like sort(data)->data and connect things up in the view?

    // it would be possible to duplicate the needed state under the VM. Not good obviously, but is there anything along those lines that could work?


    var titlebarViewModel = TitlebarViewModel()
    var listViewModel = ListViewModel()
    var toolbarViewModel = ToolbarViewModel()

    mutating func update(action: Action) {
        switch action {

        case let action as ToolbarViewModel.AddWasCommitted:
            // Super not good, just hooking things up and wondering how to refactor it
            taskList.update(action: TaskList.Create(body: action.body))

        default: ()
        }

        // Lazy way of updating children
        titlebarViewModel.taskCount = taskList.all.count

        // Now update dependents. eg.
        // this is not good though really. models are supposed to respond to actions, nothing else.
        // listViewModel.tasks = taskList.all.sorted(...)
    }



    // AHA! Are these view models just plain derived data? Don’t need any actions of their own?
    // No doesn’t work that well, can’t select computed properties using reflection :(
    // And perhaps for proper separation the view should only dispatch events from its VM
    // which are then transformed to trigger changes in other modules



}


extension TodosAppModel {
    static let example = TodosAppModel(taskList: .sample)
}
