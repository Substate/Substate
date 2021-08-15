import Substate
import SubstateMiddleware

struct Tabs: Model, SavedModel {

    var current: Tab = .tasks

    struct Select: Action {
        let tab: Tab
    }

    mutating func update(action: Action) {
        if let select = action as? Select {
            current = select.tab
        }
    }

}
