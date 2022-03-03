import SwiftUI
import Substate

// Holy grail API for actions in views:
//
//     Button("Increment", action: Counter.Increment(by: 10))
//
// Could we do this by putting a view inside the label which captures the store EnvironmentObject,
// and somehow passes access to the store up to the action closure?

extension Button {

//    public init(title: String, action: Substate.Action) {
//        self.init(action: {
//
//        }, label: {
//            Text(title)
//        })
//    }

}
