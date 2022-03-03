//import XCTest
//import Substate
//import SubstateMiddleware
//
//final class ActionFunnellerTests: XCTestCase {
//
//    struct Model1: Model {
//        var value = 0
//        func update(action: Action) {}
//    }
//
//    struct UserLoggedIn: Action { let id: String }
//    struct UserCheckedMessages: Action {}
//    struct UserLoggedOut: Action {}
//
//    struct JaneLoggedIn: Action {}
//    struct JohnLoggedIn: Action {}
//    struct JaneCompletedSession: Action {}
//
//    func testBasic() throws {
//        // There’s got to be a way to get a nice API for catching these events with type info?
//        // eg. ActionFunneller.FunnelDidComplete<JaneLoggedIn>.map { completion in ...values? ... } 
//
//        let janeLoggedIn = ActionFunnel(for: JaneLoggedIn()) {
//            UserLoggedIn.occurred { $0.id == "jane" }
//        }
//
//        let johnLoggedIn = ActionFunnel(for: JohnLoggedIn()) {
//            UserLoggedIn.occurred { $0.id == "john" }
//        }
//
//        let janeCompletedASession = ActionFunnel(for: JaneCompletedSession()) {
//            UserLoggedIn.occurred { $0.id == "jane" }
//            UserCheckedMessages.occurred()
//            UserLoggedOut.occurred()
//        }
//
//        let funneller = ActionFunneller(funnels: janeLoggedIn, johnLoggedIn, janeCompletedASession)
//        let store = Store(model: Model1(), middleware: [ActionLogger(), funneller])
//
//        store.send(UserLoggedIn(id: "jane"))
//        // > FunnelDidComplete / Jane Logged In
//
//        store.send(UserCheckedMessages())
//        store.send(UserLoggedOut())
//        // > FunnelDidComplete / Jane Completed a Session
//    }
//
//}
