import Substate

struct TitlebarViewModel: Model {

    var taskCount = 0

    var title: String {
        "\(taskCount) Tasks"
    }

    func update(action: Action) {

    }

}

extension TitlebarViewModel {
    static let example = TitlebarViewModel(taskCount: 5)
}
