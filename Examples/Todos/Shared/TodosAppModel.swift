import Foundation
import Substate

struct TodosAppModel: Model {

    var titlebar = Titlebar()
    var toolbar = Toolbar()

    var tasks = TaskList()
    var filter = Filter()
    var notifications = Notifications()

    var listViewModel = ListViewModel()

    mutating func update(action: Action) {}

}

extension TodosAppModel {
    static let example = TodosAppModel()
}
