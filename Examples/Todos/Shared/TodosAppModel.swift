import Foundation
import Substate
import SubstateMiddleware

struct TodosAppModel: Model {

    var tabs = Tabs()
    var settings = Settings()

    var tasks = Tasks()
    var createTaskScreen = CreateTaskScreenModel()

    var isLoaded = false



    var titlebar = Titlebar()
    var toolbar = Toolbar()

    var filter = Filter()
    var notifications = Notifications()

    var listViewModel = ListViewModel()

    mutating func update(action: Action) {
        if action is ModelSaver.LoadAllDidComplete {
            isLoaded = true
        }
    }

}

extension TodosAppModel {
    static let preview = TodosAppModel(tasks: .sample)
}
