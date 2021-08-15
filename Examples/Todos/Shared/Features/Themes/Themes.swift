import Substate
import SubstateMiddleware

// TODO: This is so small, perhaps it should just be an item on settings?

struct Themes: Model, SavedModel {

    var current: Theme = .sunrise

    struct Change: Action {
        let theme: Theme
    }

    mutating func update(action: Action) {
        if let change = action as? Change {
            current = change.theme
        }
    }

}
