import Substate

struct ToolbarViewModel: Model {
    var step: Step = .idle

    enum Step {
        case idle, adding(String), searching(String)
    }

    var canSaveAddedTask: Bool {
        if case .adding(let body) = step, !body.isEmpty {
            return true
        } else {
            return false
        }
    }

    struct AddButtonWasPressed: Action {}
    struct AddBodyDidChange: Action {
        let body: String
    }
    struct AddWasCommitted: Action {
        let body: String
    }

    struct SearchButtonWasPressed: Action {}
    struct SearchQueryDidChange: Action {
        let query: String
    }

    mutating func update(action: Action) {
        switch action {

        case is AddButtonWasPressed:
            step = .adding("")

        case let action as AddBodyDidChange:
            step = .adding(action.body.trimmingCharacters(in: .whitespacesAndNewlines))

        case is AddWasCommitted:
            step = .idle

        case is SearchButtonWasPressed:
            step = .searching("")

        default: ()
        }
    }
}

extension ToolbarViewModel {
    static let initial = ToolbarViewModel()
    static let searchExample = ToolbarViewModel(step: .searching("Eggs"))
}
