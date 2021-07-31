import Substate

struct Toolbar: Model {
    var sync = true

    struct ToggleSync: Action {}

    mutating func update(action: Action) {
        switch action {

        case is ToggleSync:
            sync.toggle()

        default:
            ()
        }
    }
}
