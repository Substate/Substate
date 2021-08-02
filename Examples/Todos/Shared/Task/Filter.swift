import Substate

struct Filter: Model {

    var category: Category = .all

    enum Category: CaseIterable {
        case all
        case upcoming
        case completed
        case deleted
    }

    struct Update: Action {
        let category: Category
    }

    mutating func update(action: Action) {
        if let action = action as? Update {
            category = action.category
        }
    }

}
