import Substate

struct Toolbar: Model {

    var step: Step = .idle

    enum Step {
        case idle, adding(String), searching(String)
    }

    var newTaskBody: String {
        switch step {
        case .adding(let body): return body
        default: return ""
        }
    }

    var canSaveAddedTask: Bool {
        if case .adding(let body) = step, !body.isEmpty {
            return true
        } else {
            return false
        }
    }

    struct AddButtonWasPressed: Action {}
    struct SaveButtonWasPressed: Action {}
    struct Reset: Action {}

    struct AddBodyDidChange: Action {
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

        case is SaveButtonWasPressed:
            () // step = .idle

        case let action as AddBodyDidChange:
            step = .adding(action.body.trimmingCharacters(in: .whitespacesAndNewlines))

        case is SearchButtonWasPressed:
            step = .searching("")

        case is Reset:
            step = .idle

        default: ()
        }
    }

//    var updates: some Updates {
//        AddButtonWasPressed.update {
//            step = .adding("")
//        }
//
//        AddButtonWasPressed
//            .map(Step.adding(""))
//            .update(\.step)
//
//        AddBodyDidChange
//            .map(\.body)
//            .map(Step.adding)
//            .update(\.step)
//
//        AddBodyDidChange
//            .update { step = .adding($0.body) }
//
//        AddWasCommitted
//            .map(Step.idle)
//            .update(\.step)
//
//        SearchButtonWasPressed
//            .map(Step.searching(""))
//            .assign(to: &step)
//    }

}

extension Toolbar {
    static let initial = Toolbar()
    static let searchExample = Toolbar(step: .searching("Eggs"))
}
