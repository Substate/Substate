import Foundation
import Substate

struct TodosAppModel: Model {

    var tabs = Tabs()
    var settings = Settings()

    var tasks = Tasks()
    var createTaskScreen = CreateTaskScreenModel()





    var titlebar = Titlebar()
    var toolbar = Toolbar()

    var filter = Filter()
    var notifications = Notifications()

    var listViewModel = ListViewModel()

    mutating func update(action: Action) {}

}

extension TodosAppModel {
    static let preview = TodosAppModel(tasks: .sample)
}
