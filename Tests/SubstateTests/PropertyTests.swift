import XCTest
@testable import Substate

final class PropertyTests: XCTestCase {

    // MARK: - Finding

    func testFindLabelledProperties() throws {
        struct Person { var first = "Jane"; var last = "Doe" }
        let person = Person()

        let strings = Property<String>.all(on: person)

        let firstName = Property<String>(path: .label("first"))
        let lastName = Property<String>(path: .label("last"))

        XCTAssertEqual(strings, [firstName, lastName])
    }

    func testFindLabelledDynamicProperties() throws {
        struct Person { var first = "Jane"; var last = "Doe" }
        let person = Person()

        let strings = Property<Any>.all(matching: String.self, on: person)

        let firstName = Property<Any>(matching: String.self, path: .label("first"))
        let lastName = Property<Any>(matching: String.self, path: .label("last"))

        XCTAssertEqual(strings, [firstName, lastName])
    }

    func testFindIndexedProperties() throws {
        let list: [Any] = [1, "String", 2.0]

        let integers = Property<Int>.all(on: list)
        let integerItem = Property<Int>(path: .index(0))
        XCTAssertEqual(integers, [integerItem])

        let strings = Property<String>.all(on: list)
        let stringItem = Property<String>(path: .index(1))
        XCTAssertEqual(strings, [stringItem])

        let doubles = Property<Double>.all(on: list)
        let doubleItem = Property<Double>(path: .index(2))
        XCTAssertEqual(doubles, [doubleItem])
    }

    func testFindExistentiallyIndexedProperties() throws {
        struct Person: Marker { var age: Int }
        let people: [Marker] = [Person(age: 1), Person(age: 2), Person(age: 3)]

        let ages = Property<Int>.all(on: people)

        let age1 = Property<Int>(path: .index(0), .label("age"))
        let age2 = Property<Int>(path: .index(1), .label("age"))
        let age3 = Property<Int>(path: .index(2), .label("age"))

        XCTAssertEqual(ages, [age1, age2, age3])
    }

    func testFindNestedLabelledProperties() throws {
        struct Pet { var name = "Fido" }
        struct Person { var pet1 = Pet(); var pet2 = Pet() }

        let person = Person()

        let names = Property<String>.all(on: person)
        let name1 = Property<String>(path: .label("pet1"), .label("name"))
        let name2 = Property<String>(path: .label("pet2"), .label("name"))

        XCTAssertEqual(names, [name1, name2])
    }

    func testFindNestedIndexedProperties() throws {
        struct Pet { var name = "Fido" }
        struct Person { var pets = [Pet(), Pet()] }

        let person = Person()

        let pets = Property<Pet>.all(on: person)
        let pet1 = Property<Pet>(path: .label("pets"), .index(0))
        let pet2 = Property<Pet>(path: .label("pets"), .index(1))

        XCTAssertEqual(pets, [pet1, pet2])
    }

    func testFindDeeplyNestedLabelledProperties() throws {
        struct Parent { var child1 = Child1() }
        struct Child1 { var child2 = Child2() }
        struct Child2 { var child3 = 3 }

        let parent = Parent()

        let integers = Property<Int>.all(on: parent)
        let integer3 = Property<Int>(path: .label("child1"), .label("child2"), .label("child3"))

        XCTAssertEqual(integers, [integer3])
    }

    func testFindDeeplyNestedIndexedProperties() throws {
        struct Parent { var child1 = Child1() }
        struct Child1 { var child2s = [Child2(), Child2(), Child2()] }
        struct Child2 { var child3 = 3 }

        let parent = Parent()
        let integers = Property<Int>.all(on: parent)

        let integer3s = [
            Property<Int>(path: .label("child1"), .label("child2s"), .index(0), .label("child3")),
            Property<Int>(path: .label("child1"), .label("child2s"), .index(1), .label("child3")),
            Property<Int>(path: .label("child1"), .label("child2s"), .index(2), .label("child3"))
        ]

        XCTAssertEqual(integers, integer3s)
    }

    // MARK: - Getting

    func testGetLabelledProperty() throws {
        struct Person { var name = "Jane" }
        let person = Person()

        let name = Property<String>(path: .label("name"))
        XCTAssertEqual(name.get(on: person), "Jane")
    }

    func testGetLabelledDynamicProperty() throws {
        struct Person { var name = "Jane" }
        let person = Person()

        let name = Property<Any>(matching: String.self, path: .label("name"))
        XCTAssertEqual(name.get(on: person) as? String, "Jane")
    }

    func testGetIndexedProperty() throws {
        let list: [Any] = [1, "String", 2.0]

        let integer = Property<Int>(path: .index(0))
        XCTAssertEqual(integer.get(on: list), 1)

        let string = Property<String>(path: .index(1))
        XCTAssertEqual(string.get(on: list), "String")

        let double = Property<Double>(path: .index(2))
        XCTAssertEqual(double.get(on: list), 2.0)
    }

//
//    // MARK: - Setting
//
//    func testSetTopLevelLabelledValue() throws {
//        struct Model1 { var value = 1 }
//
//        var model1 = Model1()
//        try ObjectPathFinder.setValue(at: [.label("value")], to: 2, on: &model1)
//
//        XCTAssertEqual(model1.value, 2)
//    }
//
//    func testSetTopLevelIndexedValue() throws {
//        var model1 = [1, 2 ,3]
//        try ObjectPathFinder.setValue(at: [.index(1)], to: 4, on: &model1)
//
//        XCTAssertEqual(model1, [1, 4, 3])
//    }
//
////    Fails because the system doesn’t yet work with arrays declared by protocol.
////    func testSetTopLevelProtocolIndexedValue() throws {
////        struct Model0 { var models: [HasInt] = [Model1(int: 1)] }
////        struct Model1: HasInt { var int: Int }
////
////        var model0 = Model0()
////        try ObjectPathFinder.setValue(at: [.label("models"), .index(0), .label("int")], to: 2, on: &model0)
////        XCTAssertEqual((model0.models[0] as! Model1).int, 2)
////    }
//
//    func testSetSecondLevelLabelledValue() throws {
//        struct Model1 { var value = Model2() }
//        struct Model2 { var value = 1 }
//
//        var model1 = Model1()
//        try ObjectPathFinder.setValue(at: [.label("value"), .label("value")], to: 2, on: &model1)
//
//        XCTAssertEqual(model1.value.value, 2)
//    }
//
//    func testSetSecondLevelIndexedValue() throws {
//        struct Model1 { var values = [1, 2, 3] }
//
//        var model1 = Model1()
//        try ObjectPathFinder.setValue(at: [.label("values"), .index(1)], to: 4, on: &model1)
//
//        XCTAssertEqual(model1.values, [1, 4, 3])
//    }
//
//    func testSetThirdLevelValue() throws {
//        struct Model1 { var model2 = Model2() }
//        struct Model2 { var model3 = Model3() }
//        struct Model3 { var integer = 1 }
//
//        var model1 = Model1()
//        try ObjectPathFinder.setValue(at: [.label("model2"), .label("model3"), .label("integer")], to: 2, on: &model1)
//
//        XCTAssertEqual(model1.model2.model3.integer, 2)
//    }
//
//    func testSetValueNestedInArray() throws {
//        struct Model1 { var models: [Any] = [Model2(), Model3()] }
//        struct Model2 { var model3 = Model3() }
//        struct Model3 { var integer = 1 }
//
//        var model1 = Model1()
//        try ObjectPathFinder.setValue(at: [.label("models"), .index(1), .label("integer")], to: 2, on: &model1)
//
//        XCTAssertEqual((model1.models[1] as! Model3).integer, 2)
//    }
//
//    func testSetValueNestedInArray2() throws {
//        struct Model1 { var models: [Any] = [Model2(), Model3()] }
//        struct Model2 { var model3 = Model3() }
//        struct Model3 { var integer = 1 }
//
//        var model1 = Model1()
//
//        try ObjectPathFinder.setValue(at: [.label("models"), .index(1), .label("integer")], to: 2, on: &model1)
//        XCTAssertEqual((model1.models[1] as! Model3).integer, 2)
//
//        try ObjectPathFinder.setValue(at: [.label("models"), .index(0), .label("model3"), .label("integer")], to: 3, on: &model1)
//        XCTAssertEqual((model1.models[0] as! Model2).model3.integer, 3)
//    }
//
//
//
//    struct Model1: Model {
//        var model1Value = 1
//        func update(action: Action) {}
//    }
//
//    struct Model2: Model {
//        var model2Value = 2
//        func update(action: Action) {}
//    }
//
//    struct Model3: Model, Equatable {
//        var model3Value = 3
//        func update(action: Action) {}
//    }
//
//    struct Model4: Model {
//        var model4Value = 4
//        var model1 = Model1()
//        var model2 = Model2()
//        func update(action: Action) {}
//    }
//
//    struct Model5: Model {
//        var model5Value = 5
//        var model3 = Model3()
//        var model4 = Model4()
//        var modelArray: [Any] = [Model6(), Model7()]
//        func update(action: Action) {}
//    }
//
//    struct Model6: Model {
//        var model6Value = 6
//        func update(action: Action) {}
//    }
//
//    struct Model7: Model {
//        var model7Value = 7
//        var model8 = Model8()
//        func update(action: Action) {}
//    }
//
//    struct Model8: Model, Equatable {
//        var model8Value = 8
//        func update(action: Action) {}
//    }
//
//    struct Action1: Action {}
//    class TestClass {
//        let property = 123
//    }
//    func testModelPaths() throws {
//
//        var model = Model5()
//        let values = ObjectPathFinder.values(matching: Model.self, on: model)
//
//        let expected: [ObjectPathFinder.Value] = [
//            .init(type: Model3.self, location: [.label("model3")]),
//            .init(type: Model4.self, location: [.label("model4")]),
//            .init(type: Model1.self, location: [.label("model4"), .label("model1")]),
//            .init(type: Model2.self, location: [.label("model4"), .label("model2")]),
//            .init(type: Model6.self, location: [.label("modelArray"), .index(0)]),
//            .init(type: Model7.self, location: [.label("modelArray"), .index(1)]),
//            .init(type: Model8.self, location: [.label("modelArray"), .index(1), .label("model8")]),
//        ]
//
//        XCTAssertEqual(values, expected)
//
//        XCTAssertEqual(ObjectPathFinder.getValue(at: [.label("model3")], on: model) as? Model3, model.model3)
//        XCTAssertEqual(ObjectPathFinder.getValue(at: [.label("modelArray"), .index(1), .label("model8")], on: model) as? Model8, (model.modelArray[1] as? Model7)?.model8)
//
//
//        try ObjectPathFinder.setValue(at: [.label("model3")], to: Model3(model3Value: 12345), on: &model)
//        XCTAssertEqual(model.model3.model3Value, 12345)
//
//        //
//
//        let model1Path: [ObjectPathFinder.PathSegment] = [
//            .label("model4"), .label("model1")
//        ]
//
//        try ObjectPathFinder.setValue(at: model1Path, to: Model1(model1Value: 25), on: &model)
//        XCTAssertEqual(model.model4.model1.model1Value, 25)
//
//        //
//
//        let model7Path: [ObjectPathFinder.PathSegment] = [
//            .label("modelArray"), .index(1)
//        ]
//
//        try ObjectPathFinder.setValue(at: model7Path, to: Model7(model7Value: 450, model8: .init()), on: &model)
//        XCTAssertEqual((model.modelArray[1] as? Model7)?.model7Value, 450)
//
//        //
//
//        let model8Path: [ObjectPathFinder.PathSegment] = [
//            .label("modelArray"), .index(1), .label("model8"), .label("model8Value")
//        ]
//
////        try helper.setValue(at: model8Path, to: Model8(model8Value: 500), on: &model)
//        try ObjectPathFinder.setValue(at: model8Path, to: 500, on: &model)
//        XCTAssertEqual(((model.modelArray as [Any])[1] as? Model7)?.model8.model8Value, 500)
//
//
//
//    }

}

protocol Marker {}
