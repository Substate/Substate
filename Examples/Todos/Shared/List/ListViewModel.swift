import Substate

struct ListViewModel: State {

//    var order: Order = .ascending
//    var column: Column = .date
//
//    enum Order { case ascending, descending }
//    enum Column { case date, body }
//
//    struct ChangeOrder: Action { let order: Order }
//    struct ChangeColumn: Action { let column: Column }
//
//    mutating func update(action: Action) {
//        switch action {
//
//        case let action as ChangeOrder:
//            order = action.order
//
//        case let action as ChangeColumn:
//            column = action.column
//
//        default: ()
//        }
//    }
//
//    // Kind of cool but what about other props that you would want to be a part of the VM?
//    // Eg. task count. ATM that’s not easily queried from the view without another pass through
//    // function.......
    func sort(tasks: [Task]) -> [Task] {
        // Sort according to props?
        tasks
    }

    func update(action: Action) {
        
    }

}
