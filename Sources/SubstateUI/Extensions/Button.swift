import SwiftUI

extension Button {

    public init(action: @autoclosure @escaping () -> Void, @ViewBuilder label: () -> Label) {
        self.init(action: action, label: label)
    }

    // TODO: Review all Button initialisers and create correspondoing @autoclosure versions.

}





//import Substate
//
//extension Button {
//
//    // public init(action: @escaping () -> Void, @ViewBuilder label: () -> Label)
//    public init(action: Substate.Action, @ViewBuilder label: () -> Label) {
//        StoreProvider { store in
//            Text("X")
//        }
//
//
//
//
//    }
//
//}

// Still might be worth some work on this to see whether we can get the holy grail API:

// Button("Increment", action: Counter.Increment())
