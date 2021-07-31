import Foundation
import Substate


struct TodosAppModel: Model {

    var taskList = TaskList()

    var titlebarViewModel = TitlebarViewModel()
    var listViewModel = ListViewModel()
    var toolbarViewModel = ToolbarViewModel()

    mutating func update(action: Action) {}

}

extension TodosAppModel {
    static let example = TodosAppModel()
}
