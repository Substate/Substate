import XCTest
@testable import Substate

protocol Marker {}

final class PropertyTests: XCTestCase {

    // MARK: - Finding

    func testFindLabelledProperties() throws {
        struct Person { let first = "Jane"; let last = "Doe" }
        let person = Person()

        let strings = Property<String>.all(on: person)

        let firstName = Property<String>(path: .label("first"))
        let lastName = Property<String>(path: .label("last"))

        XCTAssertEqual(strings, [firstName, lastName])
    }

    func testFindLabelledDynamicProperties() throws {
        XCTExpectFailure("We’re hoping to remove support for Property<Any> and the 'matching' dynamic property")
        struct Person { let first = "Jane"; let last = "Doe" }
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

    func testFindNestedLabelledProperties() throws {
        struct Pet { let name = "Fido" }
        struct Person { var pet1 = Pet(); var pet2 = Pet() }

        let person = Person()

        let names = Property<String>.all(on: person)
        let name1 = Property<String>(path: .label("pet1"), .label("name"))
        let name2 = Property<String>(path: .label("pet2"), .label("name"))

        XCTAssertEqual(names, [name1, name2])
    }

    func testFindNestedIndexedProperties() throws {
        struct Pet { let name = "Fido" }
        struct Person { let pets = [Pet(), Pet()] }

        let person = Person()

        let pets = Property<Pet>.all(on: person)
        let pet1 = Property<Pet>(path: .label("pets"), .index(0))
        let pet2 = Property<Pet>(path: .label("pets"), .index(1))

        XCTAssertEqual(pets, [pet1, pet2])
    }

    func testFindNestedLabelledPropertiesInArray() throws {
        struct Person { let age: Int }

        let people = [Person(age: 1), Person(age: 2), Person(age: 3)]

        let ages = Property<Int>.all(on: people)
        let age1 = Property<Int>(path: .index(0), .label("age"))
        let age2 = Property<Int>(path: .index(1), .label("age"))
        let age3 = Property<Int>(path: .index(2), .label("age"))

        XCTAssertEqual(ages, [age1, age2, age3])
    }

    func testFindDeeplyNestedLabelledProperties() throws {
        struct Parent { let child1 = Child1() }
        struct Child1 { let child2 = Child2() }
        struct Child2 { let child3 = 3 }

        let parent = Parent()

        let integers = Property<Int>.all(on: parent)
        let integer3 = Property<Int>(path: .label("child1"), .label("child2"), .label("child3"))

        XCTAssertEqual(integers, [integer3])
    }

    func testFindDeeplyNestedIndexedProperties() throws {
        struct Parent { let child1 = Child1() }
        struct Child1 { let child2s = [Child2(), Child2(), Child2()] }
        struct Child2 { let child3 = 3 }

        let parent = Parent()
        let integers = Property<Int>.all(on: parent)

        let integer3s = [
            Property<Int>(path: .label("child1"), .label("child2s"), .index(0), .label("child3")),
            Property<Int>(path: .label("child1"), .label("child2s"), .index(1), .label("child3")),
            Property<Int>(path: .label("child1"), .label("child2s"), .index(2), .label("child3"))
        ]

        XCTAssertEqual(integers, integer3s)
    }

    func testFindDifferentlyNestedPropertiesByPrimitiveType() throws {
        struct Parent { let child1 = Child1(); let child2 = Child2() }
        struct Child1 { let int: Int = 5 }
        struct Child2 { let int: Int = 10; let child3 = Child3() }
        struct Child3 { let int: Int = 15; let otherInt: Int = 20 }

        let parent = Parent()
        let integers = Property<Int>.all(on: parent)

        let expected = [
            Property<Int>(path: [.label("child1"), .label("int")]),
            Property<Int>(path: [.label("child2"), .label("int")]),
            Property<Int>(path: [.label("child2"), .label("child3"), .label("int")]),
            Property<Int>(path: [.label("child2"), .label("child3"), .label("otherInt")])
        ]

        XCTAssertEqual(integers, expected)
    }

    func testFindDifferentlyNestedPropertiesByMarkerType() throws {
        struct Parent { let child1 = Child1(); let child2 = Child2() }
        struct Child1: Marker { let child3 = Child3() }
        struct Child2: Marker {}
        struct Child3 { let child4 = Child4() }
        struct Child4 { let child5 = Child5() }
        struct Child5: Marker { let items: [Any] = [Child6(), Child7()] }
        struct Child6: Marker {}
        struct Child7 {}

        let parent = Parent()
        let markers = Property<Marker>.all(on: parent)

        let expected = [
            Property<Marker>(path: [.label("child1")]),
            Property<Marker>(path: [.label("child1"), .label("child3"), .label("child4"), .label("child5")]),
            Property<Marker>(path: [.label("child1"), .label("child3"), .label("child4"), .label("child5"), .label("items"), .index(0)]),
            Property<Marker>(path: [.label("child2")])
        ]

        XCTAssertEqual(markers, expected)
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

    func testGetIndexedProperties() throws {
        let list: [Any] = [1, "String", 2.0]

        let integer = Property<Int>(path: .index(0))
        XCTAssertEqual(integer.get(on: list), 1)

        let string = Property<String>(path: .index(1))
        XCTAssertEqual(string.get(on: list), "String")

        let double = Property<Double>(path: .index(2))
        XCTAssertEqual(double.get(on: list), 2.0)
    }

    func testGetNestedLabelledProperties() throws {
        struct Pet { let name: String }
        struct Person { var pet1 = Pet(name: "Fido"); var pet2 = Pet(name: "Rex") }

        let person = Person()

        let pet1Name = Property<String>(path: .label("pet1"), .label("name"))
        XCTAssertEqual(pet1Name.get(on: person), "Fido")

        let pet2Name = Property<String>(path: .label("pet2"), .label("name"))
        XCTAssertEqual(pet2Name.get(on: person), "Rex")
    }

    func testGetNestedIndexedProperties() throws {
        struct Pet: Equatable { let name: String }
        struct Person { let pets = [Pet(name: "Fido"), Pet(name: "Rex")] }

        let person = Person()

        let pet1 = Property<Pet>(path: .label("pets"), .index(0))
        XCTAssertEqual(pet1.get(on: person), Pet(name: "Fido"))

        let pet2 = Property<Pet>(path: .label("pets"), .index(1))
        XCTAssertEqual(pet2.get(on: person), Pet(name: "Rex"))
    }

    func testGetNestedLabelledPropertiesInArray() throws {
        struct Person { let age: Int }

        let people: [Person] = [Person(age: 1), Person(age: 2), Person(age: 3)]

        let age1 = Property<Int>(path: .index(0), .label("age"))
        XCTAssertEqual(age1.get(on: people), 1)

        let age2 = Property<Int>(path: .index(1), .label("age"))
        XCTAssertEqual(age2.get(on: people), 2)

        let age3 = Property<Int>(path: .index(2), .label("age"))
        XCTAssertEqual(age3.get(on: people), 3)
    }

    func testGetDeeplyNestedLabelledProperties() throws {
        struct Parent { let child1 = Child1() }
        struct Child1 { let child2 = Child2() }
        struct Child2 { let child3 = 3 }

        let parent = Parent()

        let integer = Property<Int>(path: .label("child1"), .label("child2"), .label("child3"))
        XCTAssertEqual(integer.get(on: parent), 3)
    }

    func testGetDeeplyNestedIndexedProperties() throws {
        struct Parent { let child1 = Child1() }
        struct Child1 { let child2s = [Child2(int: 1), Child2(int: 2), Child2(int: 3)] }
        struct Child2 { let int: Int }

        let parent = Parent()

        let int1 = Property<Int>(path: .label("child1"), .label("child2s"), .index(0), .label("int"))
        XCTAssertEqual(int1.get(on: parent), 1)

        let int2 = Property<Int>(path: .label("child1"), .label("child2s"), .index(1), .label("int"))
        XCTAssertEqual(int2.get(on: parent), 2)

        let int3 = Property<Int>(path: .label("child1"), .label("child2s"), .index(2), .label("int"))
        XCTAssertEqual(int3.get(on: parent), 3)
    }

    func testGetDifferentlyNestedPropertiesByPrimitiveType() throws {
        struct Parent { let child1 = Child1(); let child2 = Child2() }
        struct Child1 { let int: Int = 5 }
        struct Child2 { let int: Int = 10; let child3 = Child3() }
        struct Child3 { let int: Int = 15; let otherInt: Int = 20 }

        let parent = Parent()

        let int1 = Property<Int>(path: [.label("child1"), .label("int")])
        XCTAssertEqual(int1.get(on: parent), 5)

        let int2 = Property<Int>(path: [.label("child2"), .label("int")])
        XCTAssertEqual(int2.get(on: parent), 10)

        let int3 = Property<Int>(path: [.label("child2"), .label("child3"), .label("int")])
        XCTAssertEqual(int3.get(on: parent), 15)

        let int4 = Property<Int>(path: [.label("child2"), .label("child3"), .label("otherInt")])
        XCTAssertEqual(int4.get(on: parent), 20)
    }

    func testGetDifferentlyNestedPropertiesByMarkerType() throws {
        struct Parent { let child1 = Child1(); let child2 = Child2() }
        struct Child1: Marker { let child3 = Child3() }
        struct Child2: Marker, Equatable {}
        struct Child3 { let child4 = Child4() }
        struct Child4 { let child5 = Child5() }
        struct Child5: Marker { let items: [Any] = [Child6(), Child7()] }
        struct Child6: Marker {}
        struct Child7: Marker, Equatable {}

        let parent = Parent()

        let child2 = Property<Marker>(path: [.label("child2")])
        XCTAssertEqual(child2.get(on: parent) as? Child2, Child2())

        let child7 = Property<Marker>(path: [.label("child1"), .label("child3"), .label("child4"), .label("child5"), .label("items"), .index(1)])
        XCTAssertEqual(child7.get(on: parent) as? Child7, Child7())
    }

    // MARK: - Setting

    func testSetTopLevelLabelledValue() throws {
        struct Person { var name = "Joe" }

        var person = Person()

        let name = Property<String>(path: [.label("name")])
        try name.set(to: "Jane", on: &person)

        XCTAssertEqual(person.name, "Jane")
    }

    func testSetTopLevelIndexedValue() throws {
        var numbers = [1, 2 ,3]

        let secondNumber = Property<Int>(path: [.index(1)])
        try secondNumber.set(to: 5, on: &numbers)

        XCTAssertEqual(numbers, [1, 5, 3])
    }

    func testSetTopLevelProtocolIndexedValue() throws {
        // Array must be set to Any here: if it’s set to a protocol, because of the way that’s stored
        // we crash.
        struct Model0 { var models: [Any] = [Model1(int: 1)] }
        struct Model1: Marker { var int: Int }

        var model0 = Model0()

        let integer = Property<Int>(path: [.label("models"), .index(0), .label("int")])
        try integer.set(to: 3, on: &model0)

//        try ObjectPathFinder.setValue(at: [.label("models"), .index(0), .label("int")], to: 2, on: &model0)
        XCTAssertEqual((model0.models[0] as! Model1).int, 3)
    }

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
