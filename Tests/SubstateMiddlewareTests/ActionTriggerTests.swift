import XCTest
import Combine
import Substate
import SubstateMiddleware

@testable import SubstateMiddleware

final class ActionTriggerTests: XCTestCase {

    struct Action1: Action, Equatable {
        let int: Int = 1
        let double: Double = 2
        let string: String = "3"
    }

    struct Action2: Action, Equatable {}

    struct Model1: Model, Equatable {
        let int: Int = 4
        let double: Double = 5
        let string: String = "6"
        mutating func update(action: Action) {}
    }

    let find: (Model.Type) -> Model? = {
        $0 == Model1.self ? Model1() : nil
    }

    // TODO: Fix the concurrency incompatibility and re-enable these tests.

//    // MARK: - Accept
//
//    func test_accepting_an_action_by_constant() async throws {
//        let s1: ActionTriggerStep1<Action1> =
//            Action1
//                .accept(when: true)
//
//        XCTAssertNil { await s1.run(action: Action2(), find: self.find) }
//        XCTAssertEqual(s1.run(action: Action1(), find: self.find), Action1())
//
//        let s2: ActionTriggerStep1<Action1> =
//            Action1
//                .accept(when: false)
//
//        XCTAssertNil(s2.run(action: Action2(), find: find))
//        XCTAssertNil(s2.run(action: Action1(), find: find))
//    }
//
//    func test_accepting_an_action_by_optional_constant() throws {
//        let s1: ActionTriggerStep1<Action1> =
//            Action1
//                .accept(when: Optional(true))
//
//        XCTAssertNil(s1.run(action: Action2(), find: find))
//        XCTAssertEqual(s1.run(action: Action1(), find: find), Action1())
//
//        let s2: ActionTriggerStep1<Action1> =
//            Action1
//                .accept(when: Optional(false))
//
//        XCTAssertNil(s2.run(action: Action2(), find: find))
//        XCTAssertNil(s2.run(action: Action1(), find: find))
//
//        let s3: ActionTriggerStep1<Action1> =
//            Action1
//                .accept(when: Optional<Bool>.none)
//
//        XCTAssertNil(s3.run(action: Action2(), find: find))
//        XCTAssertNil(s3.run(action: Action1(), find: find))
//    }
//
//    func test_accepting_an_action_by_transform() throws {
//        let s1: ActionTriggerStep1<Action1> =
//            Action1
//                .accept(when: { _ in true })
//
//        XCTAssertNil(s1.run(action: Action2(), find: find))
//        XCTAssertEqual(s1.run(action: Action1(), find: find), Action1())
//
//        let s2: ActionTriggerStep1<Action1> =
//            Action1
//                .accept(when: { _ in false })
//
//        XCTAssertNil(s2.run(action: Action2(), find: find))
//        XCTAssertNil(s2.run(action: Action1(), find: find))
//    }
//
//    func test_accepting_an_action_by_optional_transform() throws {
//        let s1: ActionTriggerStep1<Action1> =
//            Action1
//                .accept(when: { _ in Optional(true) })
//
//        XCTAssertNil(s1.run(action: Action2(), find: find))
//        XCTAssertEqual(s1.run(action: Action1(), find: find), Action1())
//
//        let s2: ActionTriggerStep1<Action1> =
//            Action1
//                .accept(when: { _ in Optional(false) })
//
//        XCTAssertNil(s2.run(action: Action2(), find: find))
//        XCTAssertNil(s2.run(action: Action1(), find: find))
//
//        let s3: ActionTriggerStep1<Action1> =
//            Action1
//                .accept(when: { _ in Optional<Bool>.none })
//
//        XCTAssertNil(s3.run(action: Action2(), find: find))
//        XCTAssertNil(s3.run(action: Action1(), find: find))
//    }
//
//    func test_accepting_an_action_step_by_constant() throws {
//        let s1: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//                .accept(when: true)
//
//        XCTAssertEqual(s1.run(action: Action1(), find: find), 1)
//
//        let s2: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//                .accept(when: false)
//
//        XCTAssertNil(s2.run(action: Action1(), find: find))
//
//        let s3: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.double)
//                .accept(when: true)
//
//        let (s3a, s3b) = try XCTUnwrap(s3.run(action: Action1(), find: find))
//        XCTAssertEqual(s3a, 1)
//        XCTAssertEqual(s3b, 2.0)
//
//        let s4: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.double)
//                .accept(when: false)
//
//        XCTAssertNil(s4.run(action: Action1(), find: find))
//
//        let s5: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.double, \.string)
//                .accept(when: true)
//
//        let (s5a, s5b, s5c) = try XCTUnwrap(s5.run(action: Action1(), find: find))
//        XCTAssertEqual(s5a, 1)
//        XCTAssertEqual(s5b, 2.0)
//        XCTAssertEqual(s5c, "3")
//
//        let s6: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.double, \.string)
//                .accept(when: false)
//
//        XCTAssertNil(s6.run(action: Action1(), find: find))
//    }
//
//    func test_accepting_an_action_step_by_optional_constant() throws {
//        let s1: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//                .accept(when: Optional(true))
//
//        XCTAssertEqual(s1.run(action: Action1(), find: find), 1)
//
//        let s2: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//                .accept(when: Optional(false))
//
//        XCTAssertNil(s2.run(action: Action1(), find: find))
//
//        let s3: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//                .accept(when: Optional<Bool>.none)
//
//        XCTAssertNil(s3.run(action: Action1(), find: find))
//
//        let s4: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.double)
//                .accept(when: Optional(true))
//
//        let (s4a, s4b) = try XCTUnwrap(s4.run(action: Action1(), find: find))
//        XCTAssertEqual(s4a, 1)
//        XCTAssertEqual(s4b, 2.0)
//
//        let s5: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.double)
//                .accept(when: Optional(false))
//
//        XCTAssertNil(s5.run(action: Action1(), find: find))
//
//        let s6: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.double)
//                .accept(when: Optional<Bool>.none)
//
//        XCTAssertNil(s6.run(action: Action1(), find: find))
//
//        let s7: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.double, \.string)
//                .accept(when: Optional(true))
//
//        let (s7a, s7b, s7c) = try XCTUnwrap(s7.run(action: Action1(), find: find))
//        XCTAssertEqual(s7a, 1)
//        XCTAssertEqual(s7b, 2.0)
//        XCTAssertEqual(s7c, "3")
//
//        let s8: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.double, \.string)
//                .accept(when: Optional(false))
//
//        XCTAssertNil(s8.run(action: Action1(), find: find))
//
//        let s9: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.double, \.string)
//                .accept(when: Optional<Bool>.none)
//
//        XCTAssertNil(s9.run(action: Action1(), find: find))
//    }
//
//    func test_accepting_an_action_step_by_transform() throws {
//        let s1: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//                .accept(when: { (a: Int) in true })
//
//        XCTAssertNotNil(s1.run(action: Action1(), find: find))
//
//        let s2: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//                .accept(when: { (a: Int) in false })
//
//        XCTAssertNil(s2.run(action: Action1(), find: find))
//
//        let s3: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.double)
//                .accept(when: { (a: Int, b: Double) in true })
//
//        XCTAssertNotNil(s3.run(action: Action1(), find: find))
//
//        let s4: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.double)
//                .accept(when: { (a: Int, b: Double) in false })
//
//        XCTAssertNil(s4.run(action: Action1(), find: find))
//
//        let s5: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.double, \.string)
//                .accept(when: { (a: Int, b: Double, c: String) in true })
//
//        XCTAssertNotNil(s5.run(action: Action1(), find: find))
//
//        let s6: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.double, \.string)
//                .accept(when: { (a: Int, b: Double, c: String) in false })
//
//        XCTAssertNil(s6.run(action: Action1(), find: find))
//    }
//
//    func test_accepting_an_action_step_by_optional_transform() throws {
//        let s1: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//                .accept(when: { (a: Int) in Optional(true) })
//
//        XCTAssertNotNil(s1.run(action: Action1(), find: find))
//
//        let s2: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//                .accept(when: { (a: Int) in Optional(false) })
//
//        XCTAssertNil(s2.run(action: Action1(), find: find))
//
//        let s3: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//                .accept(when: { (a: Int) in Optional<Bool>.none })
//
//        XCTAssertNil(s3.run(action: Action1(), find: find))
//
//        let s4: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.double)
//                .accept(when: { (a: Int, b: Double) in Optional(true) })
//
//        XCTAssertNotNil(s4.run(action: Action1(), find: find))
//
//        let s5: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.double)
//                .accept(when: { (a: Int, b: Double) in Optional(false) })
//
//        XCTAssertNil(s5.run(action: Action1(), find: find))
//
//        let s6: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.double)
//                .accept(when: { (a: Int, b: Double) in Optional<Bool>.none })
//
//        XCTAssertNil(s6.run(action: Action1(), find: find))
//
//        let s7: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.double, \.string)
//                .accept(when: { (a: Int, b: Double, c: String) in Optional(true) })
//
//        XCTAssertNotNil(s7.run(action: Action1(), find: find))
//
//        let s8: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.double, \.string)
//                .accept(when: { (a: Int, b: Double, c: String) in Optional(false) })
//
//        XCTAssertNil(s8.run(action: Action1(), find: find))
//
//        let s9: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.double, \.string)
//                .accept(when: { (a: Int, b: Double, c: String) in Optional<Bool>.none })
//
//        XCTAssertNil(s9.run(action: Action1(), find: find))
//    }
//
//    // MARK: - Reject
//
//    func test_rejecting_an_action_by_constant() throws {
//        let s1: ActionTriggerStep1<Action1> =
//            Action1
//                .reject(when: true)
//
//        XCTAssertNil(s1.run(action: Action2(), find: find))
//        XCTAssertNil(s1.run(action: Action1(), find: find))
//
//        let s2: ActionTriggerStep1<Action1> =
//            Action1
//                .reject(when: false)
//
//        XCTAssertNil(s2.run(action: Action2(), find: find))
//        XCTAssertEqual(s2.run(action: Action1(), find: find), Action1())
//    }
//
//    func test_rejecting_an_action_by_optional_constant() throws {
//        let s1: ActionTriggerStep1<Action1> =
//            Action1
//                .reject(when: Optional(true))
//
//        XCTAssertNil(s1.run(action: Action2(), find: find))
//        XCTAssertNil(s1.run(action: Action1(), find: find))
//
//        let s2: ActionTriggerStep1<Action1> =
//            Action1
//                .reject(when: Optional(false))
//
//        XCTAssertNil(s2.run(action: Action2(), find: find))
//        XCTAssertEqual(s2.run(action: Action1(), find: find), Action1())
//
//        let s3: ActionTriggerStep1<Action1> =
//            Action1
//                .reject(when: Optional<Bool>.none)
//
//        XCTAssertNil(s3.run(action: Action2(), find: find))
//        XCTAssertEqual(s3.run(action: Action1(), find: find), Action1())
//    }
//
//    func test_rejecting_an_action_by_transform() throws {
//        let s1: ActionTriggerStep1<Action1> =
//            Action1
//                .reject(when: { _ in true })
//
//        XCTAssertNil(s1.run(action: Action2(), find: find))
//        XCTAssertNil(s1.run(action: Action1(), find: find))
//
//        let s2: ActionTriggerStep1<Action1> =
//            Action1
//                .reject(when: { _ in false })
//
//        XCTAssertNil(s2.run(action: Action2(), find: find))
//        XCTAssertEqual(s2.run(action: Action1(), find: find), Action1())
//    }
//
//    func test_rejecting_an_action_by_optional_transform() throws {
//        let s1: ActionTriggerStep1<Action1> =
//            Action1
//                .reject(when: { _ in Optional(true) })
//
//        XCTAssertNil(s1.run(action: Action2(), find: find))
//        XCTAssertNil(s1.run(action: Action1(), find: find))
//
//        let s2: ActionTriggerStep1<Action1> =
//            Action1
//                .reject(when: { _ in Optional(false) })
//
//        XCTAssertNil(s2.run(action: Action2(), find: find))
//        XCTAssertEqual(s2.run(action: Action1(), find: find), Action1())
//
//        let s3: ActionTriggerStep1<Action1> =
//            Action1
//                .reject(when: { _ in Optional<Bool>.none })
//
//        XCTAssertNil(s3.run(action: Action2(), find: find))
//        XCTAssertEqual(s3.run(action: Action1(), find: find), Action1())
//    }
//
//    func test_rejecting_an_action_step_by_constant() throws {
//        let s1: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//                .reject(when: true)
//
//        XCTAssertNil(s1.run(action: Action1(), find: find))
//
//        let s2: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//                .reject(when: false)
//
//        XCTAssertEqual(s2.run(action: Action1(), find: find), 1)
//
//        let s3: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.double)
//                .reject(when: true)
//
//        XCTAssertNil(s3.run(action: Action1(), find: find))
//
//        let s4: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.double)
//                .reject(when: false)
//
//        let (s4a, s4b) = try XCTUnwrap(s4.run(action: Action1(), find: find))
//        XCTAssertEqual(s4a, 1)
//        XCTAssertEqual(s4b, 2.0)
//
//        let s5: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.double, \.string)
//                .reject(when: true)
//
//        XCTAssertNil(s5.run(action: Action1(), find: find))
//
//        let s6: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.double, \.string)
//                .reject(when: false)
//
//        let (s6a, s6b, s6c) = try XCTUnwrap(s6.run(action: Action1(), find: find))
//        XCTAssertEqual(s6a, 1)
//        XCTAssertEqual(s6b, 2.0)
//        XCTAssertEqual(s6c, "3")
//    }
//
//    func test_rejecting_an_action_step_by_optional_constant() throws {
//        let s1: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//                .reject(when: Optional(true))
//
//        XCTAssertNil(s1.run(action: Action1(), find: find))
//
//        let s2: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//                .reject(when: Optional(false))
//
//        XCTAssertEqual(s2.run(action: Action1(), find: find), 1)
//
//        let s3: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//                .reject(when: Optional<Bool>.none)
//
//        XCTAssertEqual(s3.run(action: Action1(), find: find), 1)
//
//        let s4: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.double)
//                .reject(when: Optional(true))
//
//        XCTAssertNil(s4.run(action: Action1(), find: find))
//
//        let s5: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.double)
//                .reject(when: Optional(false))
//
//        let (s5a, s5b) = try XCTUnwrap(s5.run(action: Action1(), find: find))
//        XCTAssertEqual(s5a, 1)
//        XCTAssertEqual(s5b, 2.0)
//
//        let s6: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.double)
//                .reject(when: Optional<Bool>.none)
//
//        XCTAssertNotNil(s6.run(action: Action1(), find: find))
//
//        let s7: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.double, \.string)
//                .reject(when: Optional(true))
//
//        XCTAssertNil(s7.run(action: Action1(), find: find))
//
//        let s8: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.double, \.string)
//                .reject(when: Optional(false))
//
//        let (s8a, s8b, s8c) = try XCTUnwrap(s8.run(action: Action1(), find: find))
//        XCTAssertEqual(s8a, 1)
//        XCTAssertEqual(s8b, 2.0)
//        XCTAssertEqual(s8c, "3")
//
//        let s9: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.double, \.string)
//                .reject(when: Optional<Bool>.none)
//
//        XCTAssertNotNil(s9.run(action: Action1(), find: find))
//    }
//
//    func test_rejecting_an_action_step_by_transform() throws {
//        let s1: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//                .reject(when: { (a: Int) in true })
//
//        XCTAssertNil(s1.run(action: Action1(), find: find))
//
//        let s2: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//                .reject(when: { (a: Int) in false })
//
//        XCTAssertNotNil(s2.run(action: Action1(), find: find))
//
//        let s3: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.double)
//                .reject(when: { (a: Int, b: Double) in true })
//
//        XCTAssertNil(s3.run(action: Action1(), find: find))
//
//        let s4: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.double)
//                .reject(when: { (a: Int, b: Double) in false })
//
//        XCTAssertNotNil(s4.run(action: Action1(), find: find))
//
//        let s5: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.double, \.string)
//                .reject(when: { (a: Int, b: Double, c: String) in true })
//
//        XCTAssertNil(s5.run(action: Action1(), find: find))
//
//        let s6: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.double, \.string)
//                .reject(when: { (a: Int, b: Double, c: String) in false })
//
//        XCTAssertNotNil(s6.run(action: Action1(), find: find))
//    }
//
//    func test_rejecting_an_action_step_by_optional_transform() throws {
//        let s1: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//                .reject(when: { (a: Int) in Optional(true) })
//
//        XCTAssertNil(s1.run(action: Action1(), find: find))
//
//        let s2: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//                .reject(when: { (a: Int) in Optional(false) })
//
//        XCTAssertNotNil(s2.run(action: Action1(), find: find))
//
//        let s3: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//                .reject(when: { (a: Int) in Optional<Bool>.none })
//
//        XCTAssertNotNil(s3.run(action: Action1(), find: find))
//
//        let s4: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.double)
//                .reject(when: { (a: Int, b: Double) in Optional(true) })
//
//        XCTAssertNil(s4.run(action: Action1(), find: find))
//
//        let s5: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.double)
//                .reject(when: { (a: Int, b: Double) in Optional(false) })
//
//        XCTAssertNotNil(s5.run(action: Action1(), find: find))
//
//        let s6: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.double)
//                .reject(when: { (a: Int, b: Double) in Optional<Bool>.none })
//
//        XCTAssertNotNil(s6.run(action: Action1(), find: find))
//
//        let s7: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.double, \.string)
//                .reject(when: { (a: Int, b: Double, c: String) in Optional(true) })
//
//        XCTAssertNil(s7.run(action: Action1(), find: find))
//
//        let s8: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.double, \.string)
//                .reject(when: { (a: Int, b: Double, c: String) in Optional(false) })
//
//        XCTAssertNotNil(s8.run(action: Action1(), find: find))
//
//        let s9: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.double, \.string)
//                .reject(when: { (a: Int, b: Double, c: String) in Optional<Bool>.none })
//
//        XCTAssertNotNil(s9.run(action: Action1(), find: find))
//    }
//
//    // MARK: - Combine
//
//    func test_combining_an_action_with_constants() throws {
//        let s1: ActionTriggerStep2<Action1, Int> =
//            Action1
//                .combine(with: 123)
//
//        XCTAssertNil(s1.run(action: Action2(), find: find))
//        let (s1a, s1b) = try XCTUnwrap(s1.run(action: Action1(), find: find))
//        XCTAssertEqual(s1a, Action1())
//        XCTAssertEqual(s1b, 123)
//
//        let s2: ActionTriggerStep3<Action1, Int, Double> =
//            Action1
//                .combine(with: 123, 456.0)
//
//        XCTAssertNil(s2.run(action: Action2(), find: find))
//        let (s2a, s2b, s2c) = try XCTUnwrap(s2.run(action: Action1(), find: find))
//        XCTAssertEqual(s2a, Action1())
//        XCTAssertEqual(s2b, 123)
//        XCTAssertEqual(s2c, 456.0)
//    }
//
//    func test_combining_an_action_with_models() throws {
//        let s1: ActionTriggerStep2<Action1, Model1> =
//            Action1
//                .combine(with: Model1.self)
//
//        XCTAssertNil(s1.run(action: Action2(), find: find))
//        let (s1a, s1b) = try XCTUnwrap(s1.run(action: Action1(), find: find))
//        XCTAssertEqual(s1a, Action1())
//        XCTAssertEqual(s1b, Model1())
//
//        let s2: ActionTriggerStep3<Action1, Model1, Model1> =
//            Action1
//                .combine(with: Model1.self, Model1.self)
//
//        XCTAssertNil(s2.run(action: Action2(), find: find))
//        let (s2a, s2b, s2c) = try XCTUnwrap(s2.run(action: Action1(), find: find))
//        XCTAssertEqual(s2a, Action1())
//        XCTAssertEqual(s2b, Model1())
//        XCTAssertEqual(s2c, Model1())
//    }
//
//    func test_combining_an_action_with_model_values() throws {
//        let s1: ActionTriggerStep2<Action1, Int> =
//            Action1
//                .combine(with: \Model1.int)
//
//        XCTAssertNil(s1.run(action: Action2(), find: find))
//        let (s1a, s1b) = try XCTUnwrap(s1.run(action: Action1(), find: find))
//        XCTAssertEqual(s1a, Action1())
//        XCTAssertEqual(s1b, 4)
//
//        let s2: ActionTriggerStep3<Action1, Int, Double> =
//            Action1
//                .combine(with: \Model1.int, \Model1.double)
//
//        XCTAssertNil(s2.run(action: Action2(), find: find))
//        let (s2a, s2b, s2c) = try XCTUnwrap(s2.run(action: Action1(), find: find))
//        XCTAssertEqual(s2a, Action1())
//        XCTAssertEqual(s2b, 4)
//        XCTAssertEqual(s2c, 5.0)
//    }
//
//    func test_combining_an_action_step_with_constants() throws {
//        let s1: ActionTriggerStep2<String, Int> =
//            Action1
//                .map(\.string)
//                .combine(with: 123)
//
//        let (s1a, s1b) = try XCTUnwrap(s1.run(action: Action1(), find: find))
//        XCTAssertEqual(s1a, "3")
//        XCTAssertEqual(s1b, 123)
//
//        let s2: ActionTriggerStep3<String, Int, Double> =
//            Action1
//                .map(\.string)
//                .combine(with: 123, 456.0)
//
//        let (s2a, s2b, s2c) = try XCTUnwrap(s2.run(action: Action1(), find: find))
//        XCTAssertEqual(s2a, "3")
//        XCTAssertEqual(s2b, 123)
//        XCTAssertEqual(s2c, 456.0)
//
//        let s3: ActionTriggerStep3<String, Int, Double> =
//            Action1
//                .map(\.string, \.int)
//                .combine(with: 123.0)
//
//        let (s3a, s3b, s3c) = try XCTUnwrap(s3.run(action: Action1(), find: find))
//        XCTAssertEqual(s3a, "3")
//        XCTAssertEqual(s3b, 1)
//        XCTAssertEqual(s3c, 123.0)
//    }
//
//    func test_combining_an_action_step_with_models() throws {
//        let s1: ActionTriggerStep2<String, Model1> =
//            Action1
//                .map(\.string)
//                .combine(with: Model1.self)
//
//        let (s1a, s1b) = try XCTUnwrap(s1.run(action: Action1(), find: find))
//        XCTAssertEqual(s1a, "3")
//        XCTAssertEqual(s1b, Model1())
//
//        let s2: ActionTriggerStep3<String, Model1, Model1> =
//            Action1
//                .map(\.string)
//                .combine(with: Model1.self, Model1.self)
//
//        let (s2a, s2b, s2c) = try XCTUnwrap(s2.run(action: Action1(), find: find))
//        XCTAssertEqual(s2a, "3")
//        XCTAssertEqual(s2b, Model1())
//        XCTAssertEqual(s2c, Model1())
//
//        let s3: ActionTriggerStep3<String, Int, Model1> =
//            Action1
//                .map(\.string, \.int)
//                .combine(with: Model1.self)
//
//        let (s3a, s3b, s3c) = try XCTUnwrap(s3.run(action: Action1(), find: find))
//        XCTAssertEqual(s3a, "3")
//        XCTAssertEqual(s3b, 1)
//        XCTAssertEqual(s3c, Model1())
//    }
//
//    func test_combining_an_action_step_with_model_values() throws {
//        let s1: ActionTriggerStep2<String, Int> =
//            Action1
//                .map(\.string)
//                .combine(with: \Model1.int)
//
//        let (s1a, s1b) = try XCTUnwrap(s1.run(action: Action1(), find: find))
//        XCTAssertEqual(s1a, "3")
//        XCTAssertEqual(s1b, 4)
//
//        let s2: ActionTriggerStep3<String, Int, Double> =
//            Action1
//                .map(\.string)
//                .combine(with: \Model1.int, \Model1.double)
//
//        let (s2a, s2b, s2c) = try XCTUnwrap(s2.run(action: Action1(), find: find))
//        XCTAssertEqual(s2a, "3")
//        XCTAssertEqual(s2b, 4)
//        XCTAssertEqual(s2c, 5.0)
//
//        let s3: ActionTriggerStep3<String, Int, Double> =
//            Action1
//                .map(\.string, \.int)
//                .combine(with: \Model1.double)
//
//        let (s3a, s3b, s3c) = try XCTUnwrap(s3.run(action: Action1(), find: find))
//        XCTAssertEqual(s3a, "3")
//        XCTAssertEqual(s3b, 1)
//        XCTAssertEqual(s3c, 5.0)
//    }
//
//    // MARK: - Map
//
//    func test_map_an_action_to_properties() throws {
//        let s1: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//
//        XCTAssertNil(s1.run(action: Action2(), find: find))
//        XCTAssertEqual(s1.run(action: Action1(), find: find), 1)
//
//        let s2: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.double)
//
//        let (s2a, s2b) = try XCTUnwrap(s2.run(action: Action1(), find: find))
//        XCTAssertEqual(s2a, 1)
//        XCTAssertEqual(s2b, 2.0)
//        XCTAssertNil(s2.run(action: Action2(), find: find))
//
//        let s3: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.double, \.string)
//
//        let (s3a, s3b, s3c) = try XCTUnwrap(s3.run(action: Action1(), find: find))
//        XCTAssertEqual(s3a, 1)
//        XCTAssertEqual(s3b, 2.0)
//        XCTAssertEqual(s3c, "3")
//        XCTAssertNil(s3.run(action: Action2(), find: find))
//    }
//
//    func test_map_an_action_step_to_properties() throws {
//        let s1: ActionTriggerStep1<Int> =
//            Action1
//                .map { _ in }
//                .map { _ in 1 }
//
//        XCTAssertEqual(s1.run(action: Action1(), find: find), 1)
//
//        let s2: ActionTriggerStep2<Int, Int> =
//            Action1
//                .map { _ in }
//                .map({ _ in 1 }, { _ in 2 })
//
//        let (s2a, s2b) = try XCTUnwrap(s2.run(action: Action1(), find: find))
//        XCTAssertEqual(s2a, 1)
//        XCTAssertEqual(s2b, 2)
//
//        let s3: ActionTriggerStep3<Int, Int, Int> =
//            Action1
//                .map { _ in }
//                .map({ _ in 1 }, { _ in 2 }, { _ in 3 })
//
//        let (s3a, s3b, s3c) = try XCTUnwrap(s3.run(action: Action1(), find: find))
//        XCTAssertEqual(s3a, 1)
//        XCTAssertEqual(s3b, 2)
//        XCTAssertEqual(s3c, 3)
//
//        let s4: ActionTriggerStep1<Double> =
//            Action1
//                .map({ _ in }, { _ in })
//                .map { _, _ in 1 }
//
//        XCTAssertEqual(s4.run(action: Action1(), find: find), 1)
//
//        let s5: ActionTriggerStep1<Double> =
//            Action1
//                .map({ _ in }, { _ in }, { _ in })
//                .map { _, _, _ in 1 }
//
//        XCTAssertEqual(s5.run(action: Action1(), find: find), 1)
//    }
//
//    func test_compact_map_an_action_to_properties() throws {
//        let s1: ActionTriggerStep1<Int> =
//            Action1
//                .compactMap { _ in Optional(1) }
//
//        XCTAssertNil(s1.run(action: Action2(), find: find))
//        XCTAssertEqual(s1.run(action: Action1(), find: find), 1)
//
//        let s2: ActionTriggerStep1<Int> =
//            Action1
//                .compactMap { _ in Optional<Int>.none }
//
//        XCTAssertNil(s2.run(action: Action2(), find: find))
//        XCTAssertNil(s2.run(action: Action1(), find: find))
//    }
//
//    func test_compact_map_an_action_step_to_properties() throws {
//        let s1: ActionTriggerStep1<Int> =
//            Action1
//                .map { _ in }
//                .compactMap { _ in Optional(1) }
//
//        XCTAssertNil(s1.run(action: Action2(), find: find))
//        XCTAssertEqual(s1.run(action: Action1(), find: find), 1)
//
//        let s2: ActionTriggerStep1<Int> =
//            Action1
//                .map { _ in }
//                .compactMap { _ in Optional<Int>.none }
//
//        XCTAssertNil(s2.run(action: Action2(), find: find))
//        XCTAssertNil(s2.run(action: Action1(), find: find))
//
//        let s3: ActionTriggerStep1<Int> =
//            Action1
//                .map({ _ in }, { _ in })
//                .compactMap { _, _ in Optional(1) }
//
//        XCTAssertNil(s3.run(action: Action2(), find: find))
//        XCTAssertEqual(s3.run(action: Action1(), find: find), 1)
//
//        let s4: ActionTriggerStep1<Int> =
//            Action1
//                .map({ _ in }, { _ in })
//                .compactMap { _, _ in Optional<Int>.none }
//
//        XCTAssertNil(s4.run(action: Action2(), find: find))
//        XCTAssertNil(s4.run(action: Action1(), find: find))
//
//        let s5: ActionTriggerStep1<Int> =
//            Action1
//                .map({ _ in }, { _ in }, { _ in })
//                .compactMap { _, _, _ in Optional(1) }
//
//        XCTAssertNil(s5.run(action: Action2(), find: find))
//        XCTAssertEqual(s5.run(action: Action1(), find: find), 1)
//
//        let s6: ActionTriggerStep1<Int> =
//            Action1
//                .map({ _ in }, { _ in }, { _ in })
//                .compactMap { _, _, _ in Optional<Int>.none }
//
//        XCTAssertNil(s6.run(action: Action2(), find: find))
//        XCTAssertNil(s6.run(action: Action1(), find: find))
//    }
//
//    // MARK: - Replace
//
//    func test_replacing_an_action_with_constants() throws {
//        let s1: ActionTriggerStep1<Int> =
//            Action1
//                .replace(with: 123)
//
//        XCTAssertNil(s1.run(action: Action2(), find: find))
//        XCTAssertEqual(s1.run(action: Action1(), find: find), 123)
//
//        let s2: ActionTriggerStep2<Int, Int> =
//            Action1
//                .replace(with: 123, 456)
//
//        XCTAssertNil(s2.run(action: Action2(), find: find))
//        let (s2a, s2b) = try XCTUnwrap(s2.run(action: Action1(), find: find))
//        XCTAssertEqual(s2a, 123)
//        XCTAssertEqual(s2b, 456)
//
//        let s3: ActionTriggerStep3<Int, Int, Int> =
//            Action1
//                .replace(with: 123, 456, 789)
//
//        XCTAssertNil(s3.run(action: Action2(), find: find))
//        let (s3a, s3b, s3c) = try XCTUnwrap(s3.run(action: Action1(), find: find))
//        XCTAssertEqual(s3a, 123)
//        XCTAssertEqual(s3b, 456)
//        XCTAssertEqual(s3c, 789)
//    }
//
//    func test_replacing_an_action_with_models() throws {
//        let s1: ActionTriggerStep1<Model1> =
//            Action1
//                .replace(with: Model1.self)
//
//        XCTAssertNil(s1.run(action: Action2(), find: find))
//        XCTAssertEqual(s1.run(action: Action1(), find: find), Model1())
//
//        let s2: ActionTriggerStep2<Model1, Model1> =
//            Action1
//                .replace(with: Model1.self, Model1.self)
//
//        XCTAssertNil(s2.run(action: Action2(), find: find))
//        let (s2a, s2b) = try XCTUnwrap(s2.run(action: Action1(), find: find))
//        XCTAssertEqual(s2a, Model1())
//        XCTAssertEqual(s2b, Model1())
//
//        let s3: ActionTriggerStep3<Model1, Model1, Model1> =
//            Action1
//                .replace(with: Model1.self, Model1.self, Model1.self)
//
//        XCTAssertNil(s3.run(action: Action2(), find: find))
//        let (s3a, s3b, s3c) = try XCTUnwrap(s3.run(action: Action1(), find: find))
//        XCTAssertEqual(s3a, Model1())
//        XCTAssertEqual(s3b, Model1())
//        XCTAssertEqual(s3c, Model1())
//    }
//
//    func test_replacing_an_action_with_model_values() throws {
//        let s1: ActionTriggerStep1<Int> =
//            Action1
//                .replace(with: \Model1.int)
//
//        XCTAssertNil(s1.run(action: Action2(), find: find))
//        XCTAssertEqual(s1.run(action: Action1(), find: find), 4)
//
//        let s2: ActionTriggerStep2<Int, Double> =
//            Action1
//                .replace(with: \Model1.int, \Model1.double)
//
//        XCTAssertNil(s2.run(action: Action2(), find: find))
//        let (s2a, s2b) = try XCTUnwrap(s2.run(action: Action1(), find: find))
//        XCTAssertEqual(s2a, 4)
//        XCTAssertEqual(s2b, 5.0)
//
//        let s3: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .replace(with: \Model1.int, \Model1.double, \Model1.string)
//
//        XCTAssertNil(s3.run(action: Action2(), find: find))
//        let (s3a, s3b, s3c) = try XCTUnwrap(s3.run(action: Action1(), find: find))
//        XCTAssertEqual(s3a, 4)
//        XCTAssertEqual(s3b, 5.0)
//        XCTAssertEqual(s3c, "6")
//    }
//
//    func test_replacing_an_action_step_with_constants() throws {
//        let s1: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//                .replace(with: 123)
//
//        XCTAssertEqual(s1.run(action: Action1(), find: find), 123)
//
//        let s2: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int)
//                .replace(with: 123, 456.0)
//
//        let (s2a, s2b) = try XCTUnwrap(s2.run(action: Action1(), find: find))
//        XCTAssertEqual(s2a, 123)
//        XCTAssertEqual(s2b, 456.0)
//
//        let s3: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int)
//                .replace(with: 123, 456.0, "789")
//
//        let (s3a, s3b, s3c) = try XCTUnwrap(s3.run(action: Action1(), find: find))
//        XCTAssertEqual(s3a, 123)
//        XCTAssertEqual(s3b, 456.0)
//        XCTAssertEqual(s3c, "789")
//
//        let s4: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int, \.int)
//                .replace(with: 123)
//
//        XCTAssertEqual(s4.run(action: Action1(), find: find), 123)
//
//        let s5: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.int)
//                .replace(with: 123, 456.0)
//
//        let (s5a, s5b) = try XCTUnwrap(s5.run(action: Action1(), find: find))
//        XCTAssertEqual(s5a, 123)
//        XCTAssertEqual(s5b, 456.0)
//
//        let s6: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.int)
//                .replace(with: 123, 456.0, "789")
//
//        let (s6a, s6b, s6c) = try XCTUnwrap(s6.run(action: Action1(), find: find))
//        XCTAssertEqual(s6a, 123)
//        XCTAssertEqual(s6b, 456.0)
//        XCTAssertEqual(s6c, "789")
//
//        let s7: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int, \.int, \.int)
//                .replace(with: 123)
//
//        XCTAssertEqual(s7.run(action: Action1(), find: find), 123)
//
//        let s8: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.int, \.int)
//                .replace(with: 123, 456.0)
//
//        let (s8a, s8b) = try XCTUnwrap(s8.run(action: Action1(), find: find))
//        XCTAssertEqual(s8a, 123)
//        XCTAssertEqual(s8b, 456.0)
//
//        let s9: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.int, \.int)
//                .replace(with: 123, 456.0, "789")
//
//        let (s9a, s9b, s9c) = try XCTUnwrap(s9.run(action: Action1(), find: find))
//        XCTAssertEqual(s9a, 123)
//        XCTAssertEqual(s9b, 456.0)
//        XCTAssertEqual(s9c, "789")
//    }
//
//    func test_replacing_an_action_step_with_models() throws {
//        let s1: ActionTriggerStep1<Model1> =
//            Action1
//                .map(\.int)
//                .replace(with: Model1.self)
//
//        XCTAssertEqual(s1.run(action: Action1(), find: find), Model1())
//
//        let s2: ActionTriggerStep2<Model1, Model1> =
//            Action1
//                .map(\.int)
//                .replace(with: Model1.self, Model1.self)
//
//        let (s2a, s2b) = try XCTUnwrap(s2.run(action: Action1(), find: find))
//        XCTAssertEqual(s2a, Model1())
//        XCTAssertEqual(s2b, Model1())
//
//        let s3: ActionTriggerStep3<Model1, Model1, Model1> =
//            Action1
//                .map(\.int)
//                .replace(with: Model1.self, Model1.self, Model1.self)
//
//        let (s3a, s3b, s3c) = try XCTUnwrap(s3.run(action: Action1(), find: find))
//        XCTAssertEqual(s3a, Model1())
//        XCTAssertEqual(s3b, Model1())
//        XCTAssertEqual(s3c, Model1())
//
//        let s4: ActionTriggerStep1<Model1> =
//            Action1
//                .map(\.int, \.int)
//                .replace(with: Model1.self)
//
//        XCTAssertEqual(s4.run(action: Action1(), find: find), Model1())
//
//        let s5: ActionTriggerStep2<Model1, Model1> =
//            Action1
//                .map(\.int, \.int)
//                .replace(with: Model1.self, Model1.self)
//
//        let (s5a, s5b) = try XCTUnwrap(s5.run(action: Action1(), find: find))
//        XCTAssertEqual(s5a, Model1())
//        XCTAssertEqual(s5b, Model1())
//
//        let s6: ActionTriggerStep3<Model1, Model1, Model1> =
//            Action1
//                .map(\.int, \.int)
//                .replace(with: Model1.self, Model1.self, Model1.self)
//
//        let (s6a, s6b, s6c) = try XCTUnwrap(s6.run(action: Action1(), find: find))
//        XCTAssertEqual(s6a, Model1())
//        XCTAssertEqual(s6b, Model1())
//        XCTAssertEqual(s6c, Model1())
//
//        let s7: ActionTriggerStep1<Model1> =
//            Action1
//                .map(\.int, \.int, \.int)
//                .replace(with: Model1.self)
//
//        XCTAssertEqual(s7.run(action: Action1(), find: find), Model1())
//
//        let s8: ActionTriggerStep2<Model1, Model1> =
//            Action1
//                .map(\.int, \.int, \.int)
//                .replace(with: Model1.self, Model1.self)
//
//        let (s8a, s8b) = try XCTUnwrap(s8.run(action: Action1(), find: find))
//        XCTAssertEqual(s8a, Model1())
//        XCTAssertEqual(s8b, Model1())
//
//        let s9: ActionTriggerStep3<Model1, Model1, Model1> =
//            Action1
//                .map(\.int, \.int, \.int)
//                .replace(with: Model1.self, Model1.self, Model1.self)
//
//        let (s9a, s9b, s9c) = try XCTUnwrap(s9.run(action: Action1(), find: find))
//        XCTAssertEqual(s9a, Model1())
//        XCTAssertEqual(s9b, Model1())
//        XCTAssertEqual(s9c, Model1())
//    }
//
//    func test_replacing_an_action_step_with_model_values() throws {
//        let s1: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int)
//                .replace(with: \Model1.int)
//
//        XCTAssertEqual(s1.run(action: Action1(), find: find), 4)
//
//        let s2: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int)
//                .replace(with: \Model1.int, \Model1.double)
//
//        let (s2a, s2b) = try XCTUnwrap(s2.run(action: Action1(), find: find))
//        XCTAssertEqual(s2a, 4)
//        XCTAssertEqual(s2b, 5.0)
//
//        let s3: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int)
//                .replace(with: \Model1.int, \Model1.double, \Model1.string)
//
//        let (s3a, s3b, s3c) = try XCTUnwrap(s3.run(action: Action1(), find: find))
//        XCTAssertEqual(s3a, 4)
//        XCTAssertEqual(s3b, 5.0)
//        XCTAssertEqual(s3c, "6")
//
//        let s4: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int, \.int)
//                .replace(with: \Model1.int)
//
//        XCTAssertEqual(s4.run(action: Action1(), find: find), 4)
//
//        let s5: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.int)
//                .replace(with: \Model1.int, \Model1.double)
//
//        let (s5a, s5b) = try XCTUnwrap(s5.run(action: Action1(), find: find))
//        XCTAssertEqual(s5a, 4)
//        XCTAssertEqual(s5b, 5.0)
//
//        let s6: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.int)
//                .replace(with: \Model1.int, \Model1.double, \Model1.string)
//
//        let (s6a, s6b, s6c) = try XCTUnwrap(s6.run(action: Action1(), find: find))
//        XCTAssertEqual(s6a, 4)
//        XCTAssertEqual(s6b, 5.0)
//        XCTAssertEqual(s6c, "6")
//
//        let s7: ActionTriggerStep1<Int> =
//            Action1
//                .map(\.int, \.int, \.int)
//                .replace(with: \Model1.int)
//
//        XCTAssertEqual(s7.run(action: Action1(), find: find), 4)
//
//        let s8: ActionTriggerStep2<Int, Double> =
//            Action1
//                .map(\.int, \.int, \.int)
//                .replace(with: \Model1.int, \Model1.double)
//
//        let (s8a, s8b) = try XCTUnwrap(s8.run(action: Action1(), find: find))
//        XCTAssertEqual(s8a, 4)
//        XCTAssertEqual(s8b, 5.0)
//
//        let s9: ActionTriggerStep3<Int, Double, String> =
//            Action1
//                .map(\.int, \.int, \.int)
//                .replace(with: \Model1.int, \Model1.double, \Model1.string)
//
//        let (s9a, s9b, s9c) = try XCTUnwrap(s9.run(action: Action1(), find: find))
//        XCTAssertEqual(s9a, 4)
//        XCTAssertEqual(s9b, 5.0)
//        XCTAssertEqual(s9c, "6")
//    }
//
//    // MARK: - Trigger
//
//    func test_triggering_from_an_action_with_a_constant_action() throws {
//        let t1: ActionTriggerStepFinal<Action2> =
//            Action1
//                .trigger(Action2())
//
//        XCTAssertNil(t1.run(action: Action2(), find: find))
//        XCTAssertEqual(t1.run(action: Action1(), find: find), Action2())
//    }
//
//    func test_triggering_from_an_action_with_an_optional_constant_action() throws {
//        let t1: ActionTriggerStepFinal<Action2> =
//            Action1
//                .trigger(Optional(Action2()))
//
//        XCTAssertNil(t1.run(action: Action2(), find: find))
//        XCTAssertEqual(t1.run(action: Action1(), find: find), Action2())
//
//        let t2: ActionTriggerStepFinal<Action2> =
//            Action1
//                .trigger(Optional<Action2>.none)
//
//        XCTAssertNil(t2.run(action: Action1(), find: find))
//        XCTAssertNil(t2.run(action: Action2(), find: find))
//    }
//
//    func test_triggering_from_an_action_with_a_function() throws {
//        let t1: ActionTriggerStepFinal<Action2> =
//            Action1
//                .trigger { Action2() }
//
//        XCTAssertNil(t1.run(action: Action2(), find: find))
//        XCTAssertEqual(t1.run(action: Action1(), find: find), Action2())
//    }
//
//    func test_triggering_from_an_action_with_an_optional_function() throws {
//        let t1: ActionTriggerStepFinal<Action2> =
//            Action1
//                .trigger { Optional(Action2()) }
//
//        XCTAssertNil(t1.run(action: Action2(), find: find))
//        XCTAssertEqual(t1.run(action: Action1(), find: find), Action2())
//
//        let t2: ActionTriggerStepFinal<Action2> =
//            Action1
//                .trigger { Optional<Action2>.none }
//
//        XCTAssertNil(t2.run(action: Action1(), find: find))
//        XCTAssertNil(t2.run(action: Action2(), find: find))
//    }
//
//    func test_triggering_from_an_action_with_a_transform() throws {
//        let t1: ActionTriggerStepFinal<Action1> =
//            Action1
//                .trigger { $0 }
//
//        XCTAssertNil(t1.run(action: Action2(), find: find))
//        XCTAssertEqual(t1.run(action: Action1(), find: find), Action1())
//    }
//
//    func test_triggering_from_an_action_with_an_optional_transform() throws {
//        let t1: ActionTriggerStepFinal<Action1> =
//            Action1
//            .trigger { Optional($0) }
//
//        XCTAssertNil(t1.run(action: Action2(), find: find))
//        XCTAssertEqual(t1.run(action: Action1(), find: find), Action1())
//
//        let t2: ActionTriggerStepFinal<Action1> =
//            Action1
//                .trigger { Optional<Action1>.none }
//
//        XCTAssertNil(t2.run(action: Action1(), find: find))
//        XCTAssertNil(t2.run(action: Action2(), find: find))
//    }
//
//    func test_triggering_from_an_action_step_with_a_constant_action() throws {
//        let t1: ActionTriggerStepFinal<Action2> =
//            Action1
//                .map(\.int)
//                .trigger(Action2())
//
//        XCTAssertNil(t1.run(action: Action2(), find: find))
//        XCTAssertEqual(t1.run(action: Action1(), find: find), Action2())
//
//        let t2: ActionTriggerStepFinal<Action2> =
//            Action1
//                .map(\.int, \.int)
//                .trigger(Action2())
//
//        XCTAssertNil(t2.run(action: Action2(), find: find))
//        XCTAssertEqual(t2.run(action: Action1(), find: find), Action2())
//
//        let t3: ActionTriggerStepFinal<Action2> =
//            Action1
//                .map(\.int, \.int, \.int)
//                .trigger(Action2())
//
//        XCTAssertNil(t3.run(action: Action2(), find: find))
//        XCTAssertEqual(t3.run(action: Action1(), find: find), Action2())
//    }
//
//    func test_triggering_from_an_action_step_with_an_optional_constant_action() throws {
//        let t1: ActionTriggerStepFinal<Action2> =
//            Action1
//                .map(\.int)
//                .trigger(Optional(Action2()))
//
//        XCTAssertNil(t1.run(action: Action2(), find: find))
//        XCTAssertEqual(t1.run(action: Action1(), find: find), Action2())
//
//        let t2: ActionTriggerStepFinal<Action2> =
//            Action1
//                .map(\.int, \.int)
//                .trigger(Optional(Action2()))
//
//        XCTAssertNil(t2.run(action: Action2(), find: find))
//        XCTAssertEqual(t2.run(action: Action1(), find: find), Action2())
//
//        let t3: ActionTriggerStepFinal<Action2> =
//            Action1
//                .map(\.int, \.int, \.int)
//                .trigger(Optional(Action2()))
//
//        XCTAssertNil(t3.run(action: Action2(), find: find))
//        XCTAssertEqual(t3.run(action: Action1(), find: find), Action2())
//    }
//
//    func test_triggering_from_an_action_step_with_a_function() throws {
//        let t1: ActionTriggerStepFinal<Action2> =
//            Action1
//                .map(\.int)
//                .trigger { Action2() }
//
//        XCTAssertNil(t1.run(action: Action2(), find: find))
//        XCTAssertEqual(t1.run(action: Action1(), find: find), Action2())
//
//        let t2: ActionTriggerStepFinal<Action2> =
//            Action1
//                .map(\.int, \.int)
//                .trigger { Action2() }
//
//        XCTAssertNil(t2.run(action: Action2(), find: find))
//        XCTAssertEqual(t2.run(action: Action1(), find: find), Action2())
//
//        let t3: ActionTriggerStepFinal<Action2> =
//            Action1
//                .map(\.int, \.int, \.int)
//                .trigger { Action2() }
//
//        XCTAssertNil(t3.run(action: Action2(), find: find))
//        XCTAssertEqual(t3.run(action: Action1(), find: find), Action2())
//    }
//
//    func test_triggering_from_an_action_step_with_a_transform() throws {
//        let t1: ActionTriggerStepFinal<Action2> =
//            Action1
//                .map(\.int)
//                .trigger { _ in Action2() }
//
//        XCTAssertNil(t1.run(action: Action2(), find: find))
//        XCTAssertEqual(t1.run(action: Action1(), find: find), Action2())
//
//        let t2: ActionTriggerStepFinal<Action2> =
//            Action1
//                .map(\.int, \.int)
//                .trigger { _, _ in Action2() }
//
//        XCTAssertNil(t2.run(action: Action2(), find: find))
//        XCTAssertEqual(t2.run(action: Action1(), find: find), Action2())
//
//        let t3: ActionTriggerStepFinal<Action2> =
//            Action1
//                .map(\.int, \.int, \.int)
//                .trigger { _, _, _ in Action2() }
//
//        XCTAssertNil(t3.run(action: Action2(), find: find))
//        XCTAssertEqual(t3.run(action: Action1(), find: find), Action2())
//    }
//
//    func test_triggering_from_an_action_step_with_an_optional_transform() throws {
//        let t1: ActionTriggerStepFinal<Action2> =
//            Action1
//                .map(\.int)
//                .trigger { _ in Optional(Action2()) }
//
//        XCTAssertNil(t1.run(action: Action2(), find: find))
//        XCTAssertEqual(t1.run(action: Action1(), find: find), Action2())
//
//        let t2: ActionTriggerStepFinal<Action2> =
//            Action1
//                .map(\.int, \.int)
//                .trigger { _, _ in Optional(Action2()) }
//
//        XCTAssertNil(t2.run(action: Action2(), find: find))
//        XCTAssertEqual(t2.run(action: Action1(), find: find), Action2())
//
//        let t3: ActionTriggerStepFinal<Action2> =
//            Action1
//                .map(\.int, \.int, \.int)
//                .trigger { _, _, _ in Optional(Action2()) }
//
//        XCTAssertNil(t3.run(action: Action2(), find: find))
//        XCTAssertEqual(t3.run(action: Action1(), find: find), Action2())
//    }
//
//    func test_triggering_from_an_action_step_where_the_output_is_already_an_action() throws {
//        let t1: ActionTriggerStepFinal<Action2> =
//            Action1
//                .map { _ in Action2() }
//                .trigger()
//
//        XCTAssertNil(t1.run(action: Action2(), find: find))
//        XCTAssertEqual(t1.run(action: Action1(), find: find), Action2())
//
//        // Not sure how to make the following work...
//        //
//        // let _: ActionTrigger<Action1> =
//        //    Action1
//        //        .map { Optional($0) }
//        //        .trigger()
//    }
//
//    // MARK: - Public API
//
//    func testResultBuilderAPI() throws {
//        let triggerGroup1 = ActionTriggers {
//            Action1
//                .trigger(Action2())
//
//            Action2
//                .replace(with: \Model1.string)
//                .trigger(Action1())
//        }
//
//        let triggerGroup2 = ActionTriggers {
//            triggerGroup1
//
//            Action1
//                .accept(when: false)
//                .trigger(Action2())
//        }
//
//        // TODO: Would love to be able to test this more cleanly.
//        // But it’s tricky because the [Action] return type can’t be equatable?
//
//        let t1 = triggerGroup2.run(action: Action1(), find: find)
//        XCTAssertEqual(try XCTUnwrap(t1[0] as? Action2), Action2())
//
//        let t2 = triggerGroup2.run(action: Action2(), find: find)
//        XCTAssertEqual(try XCTUnwrap(t2[0] as? Action1), Action1())
//    }

}
