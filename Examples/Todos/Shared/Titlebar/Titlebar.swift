import Substate
import Foundation

struct Titlebar: Model {

    var count: Int = 0
    var category: Filter.Category = .upcoming

//    var filter = Filter()
//    var taskList = TaskList()


    struct UpdateCount: Action {
        let count: Int
    }

    struct UpdateCategory: Action {
        let category: Filter.Category
    }

    var title: AttributedString {
        .init(localized: "^[\(count) \(categoryTitle) \("Task")](inflect:true)")
//        [String(taskList.filteredTaskCount), filterCategoryName, tasksString]
//            .compactMap { $0 }
//            .joined(separator: " ")

    }


    // Just for testing
//    struct FilterDidChange: Action {
//        let filter: Filter
//    }

    var categoryTitle: String {
        switch category {
        case .all: return ""
        case .upcoming: return "Upcoming"
        case .completed: return "Completed"
        case .deleted: return "Deleted"
        }
    }

//    private var tasksString: String {
//        taskList.filteredTaskCount == 1 ? "Task" : "Tasks"
//    }

    mutating func update(action: Action) {
        if let action = action as? UpdateCount {
            count = action.count
        }
    }

}

extension Titlebar {
    static let example = Titlebar()
}
