import Substate

struct TitlebarViewModel: Model {

    var filter = Filter()
    var taskList = TaskList()

    var title: String {
        [String(taskList.filteredTaskCount), filterCategoryName, tasksString]
            .compactMap { $0 }
            .joined(separator: " ")
    }

    // Just for testing
    struct FilterDidChange: Action {
        let filter: Filter
    }

    private var filterCategoryName: String? {
        switch filter.category {
        case .all: return nil
        case .upcoming: return "Upcoming"
        case .completed: return "Completed"
        case .deleted: return "Deleted"
        }
    }

    private var tasksString: String {
        taskList.filteredTaskCount == 1 ? "Task" : "Tasks"
    }

    func update(action: Action) {}

}

extension TitlebarViewModel {
    static let example = TitlebarViewModel()
}
