import Substate

struct CreateTaskScreenModel: Model {

    var isActive = false

    struct Toggle: Action { let isActive: Bool }

    mutating func update(action: Action) {
        switch action {
        case let toggle as Toggle: isActive = toggle.isActive
        default: ()
        }
    }

}
