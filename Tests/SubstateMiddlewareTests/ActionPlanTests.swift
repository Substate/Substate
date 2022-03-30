import XCTest
import Combine

@testable import Substate
@testable import SubstateMiddleware

@MainActor final class ActionPlanTests: XCTestCase {

    struct TestAction: Action {}
    struct OtherTestAction: Action {}

    struct User: Model { let id: Int, name: String }
    struct Audio: Model { let isRecording: Bool }

    func test1() async throws {

//        _ = ActionPlan(User.self) { user in
//
//            TestAction
//                .subscribe()
//
//            TestAction
//                .subscribe()
//                .map { _ in user.id > 5 }
//                .map { high -> Action in high ? TestAction() : OtherTestAction() }
//                .eraseToAnyPublisher()
//
//            TestAction
//                .subscribe()
//                .filter { _ in user.id > 5 }
//                .map { _ in TestAction() as Action }
//                .eraseToAnyPublisher()

//            Other API ideas...

//            let userId = (\User.id).subscribe()
//            let loginButtonPressed = LoginScreen.ButtonWasPressed.subscribe()
//
//            LoginScreen.ButtonWasPressed
//                .subscribe(with: \User.id)
//                .map { buttonPress, userId in ... }
//
//            userId
//                .withLatestFrom(loginButtonPressed)
//                .map { id, action in LoginService.Login(userId: id) }

//            for await test in TestAction.stream() {
//                if test.property > 5 {
//                    await store.dispatch(OtherTestAction())
//                }
//            }

//            We really need streams of model values!
//            
//            (\User.name).subscribe()
//                .perform { print("The user’s name changed!") }

//        }

    }

}
