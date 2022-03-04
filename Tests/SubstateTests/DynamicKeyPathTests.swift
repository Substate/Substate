import XCTest
@testable import Substate

final class DynamicKeyPathTests: XCTestCase {

    // MARK: - Finding

    func testFindLabelledProperties() throws {
        struct Person { let first = "Jane"; let last = "Doe" }
        let person = Person()

        let strings = DynamicKeyPath<String>.all(on: person)

        let firstName = DynamicKeyPath<String>(path: .label("first"))
        let lastName = DynamicKeyPath<String>(path: .label("last"))

        XCTAssertEqual(strings, [firstName, lastName])
    }

    func testFindLabelledDynamicProperties() throws {
        struct Person { let first = "Jane"; let last = "Doe" }
        let person = Person()

        let strings = DynamicKeyPath<Any>.all(matching: String.self, on: person)

        let firstName = DynamicKeyPath<Any>(matching: String.self, path: .label("first"))
        let lastName = DynamicKeyPath<Any>(matching: String.self, path: .label("last"))

        XCTAssertEqual(strings, [firstName, lastName])
    }

    func testFindIndexedProperties() throws {
        let list: [Any] = [1, "String", 2.0]

        let integers = DynamicKeyPath<Int>.all(on: list)
        let integerItem = DynamicKeyPath<Int>(path: .index(0))
        XCTAssertEqual(integers, [integerItem])

        let strings = DynamicKeyPath<String>.all(on: list)
        let stringItem = DynamicKeyPath<String>(path: .index(1))
        XCTAssertEqual(strings, [stringItem])

        let doubles = DynamicKeyPath<Double>.all(on: list)
        let doubleItem = DynamicKeyPath<Double>(path: .index(2))
        XCTAssertEqual(doubles, [doubleItem])
    }

    func testFindNestedLabelledProperties() throws {
        struct Pet { let name = "Fido" }
        struct Person { var pet1 = Pet(); var pet2 = Pet() }

        let person = Person()

        let names = DynamicKeyPath<String>.all(on: person)
        let name1 = DynamicKeyPath<String>(path: .label("pet1"), .label("name"))
        let name2 = DynamicKeyPath<String>(path: .label("pet2"), .label("name"))

        XCTAssertEqual(names, [name1, name2])
    }

    func testFindNestedIndexedProperties() throws {
        struct Pet { let name = "Fido" }
        struct Person { let pets = [Pet(), Pet()] }

        let person = Person()

        let pets = DynamicKeyPath<Pet>.all(on: person)
        let pet1 = DynamicKeyPath<Pet>(path: .label("pets"), .index(0))
        let pet2 = DynamicKeyPath<Pet>(path: .label("pets"), .index(1))

        XCTAssertEqual(pets, [pet1, pet2])
    }

    func testFindNestedLabelledPropertiesInArray() throws {
        struct Person { let age: Int }

        let people = [Person(age: 1), Person(age: 2), Person(age: 3)]

        let ages = DynamicKeyPath<Int>.all(on: people)
        let age1 = DynamicKeyPath<Int>(path: .index(0), .label("age"))
        let age2 = DynamicKeyPath<Int>(path: .index(1), .label("age"))
        let age3 = DynamicKeyPath<Int>(path: .index(2), .label("age"))

        XCTAssertEqual(ages, [age1, age2, age3])
    }

    func testFindDeeplyNestedLabelledProperties() throws {
        struct Parent { let child1 = Child1() }
        struct Child1 { let child2 = Child2() }
        struct Child2 { let child3 = 3 }

        let parent = Parent()

        let integers = DynamicKeyPath<Int>.all(on: parent)
        let integer3 = DynamicKeyPath<Int>(path: .label("child1"), .label("child2"), .label("child3"))

        XCTAssertEqual(integers, [integer3])
    }

    func testFindDeeplyNestedIndexedProperties() throws {
        struct Parent { let child1 = Child1() }
        struct Child1 { let child2s = [Child2(), Child2(), Child2()] }
        struct Child2 { let child3 = 3 }

        let parent = Parent()
        let integers = DynamicKeyPath<Int>.all(on: parent)

        let integer3s = [
            DynamicKeyPath<Int>(path: .label("child1"), .label("child2s"), .index(0), .label("child3")),
            DynamicKeyPath<Int>(path: .label("child1"), .label("child2s"), .index(1), .label("child3")),
            DynamicKeyPath<Int>(path: .label("child1"), .label("child2s"), .index(2), .label("child3"))
        ]

        XCTAssertEqual(integers, integer3s)
    }

    func testFindDifferentlyNestedPropertiesByPrimitiveType() throws {
        struct Parent { let child1 = Child1(); let child2 = Child2() }
        struct Child1 { let int: Int = 5 }
        struct Child2 { let int: Int = 10; let child3 = Child3() }
        struct Child3 { let int: Int = 15; let otherInt: Int = 20 }

        let parent = Parent()
        let integers = DynamicKeyPath<Int>.all(on: parent)

        let expected = [
            DynamicKeyPath<Int>(path: [.label("child1"), .label("int")]),
            DynamicKeyPath<Int>(path: [.label("child2"), .label("int")]),
            DynamicKeyPath<Int>(path: [.label("child2"), .label("child3"), .label("int")]),
            DynamicKeyPath<Int>(path: [.label("child2"), .label("child3"), .label("otherInt")])
        ]

        XCTAssertEqual(integers, expected)
    }

    func testFindDifferentlyNestedPropertiesByModelType() throws {
        struct Parent { let child1 = Child1(); let child2 = Child2() }
        struct Child1: Model { let child3 = Child3() }
        struct Child2: Model {}
        struct Child3 { let child4 = Child4() }
        struct Child4 { let child5 = Child5() }
        struct Child5: Model { let items: [Model] = [Child6(), Child7()] }
        struct Child6: Model {}
        struct Child7: Model {}

        let parent = Parent()
        let models = DynamicKeyPath<Model>.all(on: parent)

        let expected = [
            DynamicKeyPath<Model>(matching: Child1.self, path: [.label("child1")]),
            DynamicKeyPath<Model>(matching: Child5.self, path: [.label("child1"), .label("child3"), .label("child4"), .label("child5")]),
            DynamicKeyPath<Model>(matching: Child6.self, path: [.label("child1"), .label("child3"), .label("child4"), .label("child5"), .label("items"), .index(0)]),
            DynamicKeyPath<Model>(matching: Child7.self, path: [.label("child1"), .label("child3"), .label("child4"), .label("child5"), .label("items"), .index(1)]),
            DynamicKeyPath<Model>(matching: Child2.self, path: [.label("child2")])
        ]

        XCTAssertEqual(models, expected)
    }

    // MARK: - Getting

    func testGetLabelledValue() throws {
        struct Person { var name = "Jane" }
        let person = Person()

        let name = DynamicKeyPath<String>(path: .label("name"))
        XCTAssertEqual(name.get(on: person), "Jane")
    }

    func testGetLabelledDynamicValue() throws {
        struct Person { var name = "Jane" }
        let person = Person()

        let name = DynamicKeyPath<Any>(matching: String.self, path: .label("name"))
        XCTAssertEqual(name.get(on: person) as? String, "Jane")
    }

    func testGetIndexedValue() throws {
        XCTExpectFailure("We currently only support arrays of type [Model]")

        let list: [Any] = [1, "String", 2.0]

        let integer = DynamicKeyPath<Int>(path: .index(0))
        XCTAssertEqual(integer.get(on: list), 1)

        let string = DynamicKeyPath<String>(path: .index(1))
        XCTAssertEqual(string.get(on: list), "String")

        let double = DynamicKeyPath<Double>(path: .index(2))
        XCTAssertEqual(double.get(on: list), 2.0)
    }

    func testGetNestedLabelledValue() throws {
        struct Pet { let name: String }
        struct Person { var pet1 = Pet(name: "Fido"); var pet2 = Pet(name: "Rex") }

        let person = Person()

        let pet1Name = DynamicKeyPath<String>(path: .label("pet1"), .label("name"))
        XCTAssertEqual(pet1Name.get(on: person), "Fido")

        let pet2Name = DynamicKeyPath<String>(path: .label("pet2"), .label("name"))
        XCTAssertEqual(pet2Name.get(on: person), "Rex")
    }

    func testGetNestedIndexedValue() throws {
        struct Pet: Model, Equatable { let name: String }
        struct Person { let pets = [Pet(name: "Fido"), Pet(name: "Rex")] }

        let person = Person()

        let pet1 = DynamicKeyPath<Pet>(path: .label("pets"), .index(0))
        XCTAssertEqual(pet1.get(on: person), Pet(name: "Fido"))

        let pet2 = DynamicKeyPath<Pet>(path: .label("pets"), .index(1))
        XCTAssertEqual(pet2.get(on: person), Pet(name: "Rex"))
    }

    func testGetNestedLabelledPropertiesInArray() throws {
        struct Person: Model { let age: Int }

        let people: [Model] = [Person(age: 1), Person(age: 2), Person(age: 3)]

        let age1 = DynamicKeyPath<Int>(path: .index(0), .label("age"))
        XCTAssertEqual(age1.get(on: people), 1)

        let age2 = DynamicKeyPath<Int>(path: .index(1), .label("age"))
        XCTAssertEqual(age2.get(on: people), 2)

        let age3 = DynamicKeyPath<Int>(path: .index(2), .label("age"))
        XCTAssertEqual(age3.get(on: people), 3)
    }

    func testGetDeeplyNestedLabelledProperties() throws {
        struct Parent { let child1 = Child1() }
        struct Child1 { let child2 = Child2() }
        struct Child2 { let child3 = 3 }

        let parent = Parent()

        let integer = DynamicKeyPath<Int>(path: .label("child1"), .label("child2"), .label("child3"))
        XCTAssertEqual(integer.get(on: parent), 3)
    }

    func testGetDeeplyNestedIndexedProperties() throws {
        struct Parent { let child1 = Child1() }
        struct Child1 { let child2s = [Child2(int: 1), Child2(int: 2), Child2(int: 3)] }
        struct Child2: Model { let int: Int }

        let parent = Parent()

        let int1 = DynamicKeyPath<Int>(path: .label("child1"), .label("child2s"), .index(0), .label("int"))
        XCTAssertEqual(int1.get(on: parent), 1)

        let int2 = DynamicKeyPath<Int>(path: .label("child1"), .label("child2s"), .index(1), .label("int"))
        XCTAssertEqual(int2.get(on: parent), 2)

        let int3 = DynamicKeyPath<Int>(path: .label("child1"), .label("child2s"), .index(2), .label("int"))
        XCTAssertEqual(int3.get(on: parent), 3)
    }

    func testGetDifferentlyNestedPropertiesByPrimitiveType() throws {
        struct Parent { let child1 = Child1(); let child2 = Child2() }
        struct Child1 { let int: Int = 5 }
        struct Child2 { let int: Int = 10; let child3 = Child3() }
        struct Child3 { let int: Int = 15; let otherInt: Int = 20 }

        let parent = Parent()

        let int1 = DynamicKeyPath<Int>(path: [.label("child1"), .label("int")])
        XCTAssertEqual(int1.get(on: parent), 5)

        let int2 = DynamicKeyPath<Int>(path: [.label("child2"), .label("int")])
        XCTAssertEqual(int2.get(on: parent), 10)

        let int3 = DynamicKeyPath<Int>(path: [.label("child2"), .label("child3"), .label("int")])
        XCTAssertEqual(int3.get(on: parent), 15)

        let int4 = DynamicKeyPath<Int>(path: [.label("child2"), .label("child3"), .label("otherInt")])
        XCTAssertEqual(int4.get(on: parent), 20)
    }

    func testGetDifferentlyNestedPropertiesByModelType() throws {
        struct Parent { let child1 = Child1(); let child2 = Child2() }
        struct Child1: Model { let child3 = Child3() }
        struct Child2: Model, Equatable {}
        struct Child3 { let child4 = Child4() }
        struct Child4 { let child5 = Child5() }
        struct Child5: Model { let items: [Any] = [Child6(), Child7()] }
        struct Child6: Model {}
        struct Child7: Model, Equatable {}

        let parent = Parent()

        let child2 = DynamicKeyPath<Model>(path: [.label("child2")])
        XCTAssertEqual(child2.get(on: parent) as? Child2, Child2())

        let child7 = DynamicKeyPath<Model>(path: [.label("child1"), .label("child3"), .label("child4"), .label("child5"), .label("items"), .index(1)])
        XCTAssertEqual(child7.get(on: parent) as? Child7, Child7())
    }

    // MARK: - Setting

    func testSetLabelledValue() throws {
        struct Person { var name = "Joe" }

        var person = Person()

        let name = DynamicKeyPath<String>(path: .label("name"))
        try name.set(to: "Jane", on: &person)

        XCTAssertEqual(person.name, "Jane")
    }

    func testSetIndexedValue() throws {
        XCTExpectFailure("We currently only support arrays of type [Model]")

        var numbers = [1, 2 ,3]

        let secondNumber = DynamicKeyPath<Int>(path: .index(1))
        try secondNumber.set(to: 5, on: &numbers)

        XCTAssertEqual(numbers, [1, 5, 3])
    }

    func testSetIndexedExistentialValue() throws {
        struct Model0 { var models: [Any] = [Model1(int: 1)] }
        struct Model1: Model { var int: Int }

        var model0 = Model0()

        let integer = DynamicKeyPath<Int>(path: .label("models"), .index(0), .label("int"))
        try integer.set(to: 3, on: &model0)

        XCTAssertEqual((model0.models[0] as! Model1).int, 3)
    }

    func testSetNestedLabelledValue() throws {
        struct Model1 { var value = Model2() }
        struct Model2 { var value = 1 }

        var model1 = Model1()
        let integer = DynamicKeyPath<Int>(path: .label("value"), .label("value"))
        try integer.set(to: 3, on: &model1)

        XCTAssertEqual(model1.value.value, 3)
    }

    func testSetNestedIndexedValue() throws {
        XCTExpectFailure("We currently only support arrays of type [Model]")

        struct Model1 { var values = [1, 2, 3] }

        var model1 = Model1()
        let integer = DynamicKeyPath<Int>(path: .label("values"), .index(1))
        try integer.set(to: 4, on: &model1)

        XCTAssertEqual(model1.values, [1, 4, 3])
    }

    func testSetNestedStructValue() throws {
        struct Model1 { var model2 = Model2() }
        struct Model2 { var model3 = Model3() }
        struct Model3: Equatable { var integer = 1; var string = "two"; var double = 3.0 }

        var model1 = Model1()

        let model3 = DynamicKeyPath<Model3>(path: .label("model2"), .label("model3"))
        try model3.set(to: Model3(integer: 4, string: "five", double: 6.0), on: &model1)

        XCTAssertEqual(model1.model2.model3, Model3(integer: 4, string: "five", double: 6.0))
    }

    func testSetNestedEnumValue() throws {
        struct Model1 { var model2 = Model2() }
        struct Model2 { var model3 = Model3.one(1) }
        enum Model3: Equatable { case one(Int), two(String), three(Double) }

        var model1 = Model1()

        let model3 = DynamicKeyPath<Model3>(path: .label("model2"), .label("model3"))
        try model3.set(to: .three(3.0), on: &model1)

        XCTAssertEqual(model1.model2.model3, .three(3.0))
    }

    func testSetValueNestedInArray() throws {
        struct Model2: Model {
            var integer = 2
            var model3 = Model3()
            mutating func update(action: Action) {}
        }

        struct Model3: Model, Equatable {
            var integer = 3
            mutating func update(action: Action) {}
        }

        var model1: [Model] = [Model2(), Model3()]

        let integer = DynamicKeyPath<Int>(path: .index(1), .label("integer"))
        try integer.set(to: 2, on: &model1)
        XCTAssertEqual(try XCTUnwrap(model1[1] as? Model3)?.integer, 2)

        let model3 = DynamicKeyPath<Model3>(path: .index(0), .label("model3"))
        try model3.set(to: Model3(integer: 5), on: &model1)
        XCTAssertEqual(try XCTUnwrap((model1[0] as? Model2)?.model3), Model3(integer: 5))
    }

}
