import Runtime

/// A utility which searches through objects and identifies the paths of certain values.
///
enum ObjectPathFinder {

    struct Value {
        let type: Any.Type
        let location: [PathSegment]
    }

    enum PathSegment: Equatable {
        case index(Int)
        case label(String)
    }



    static func values<P>(matching predicate: P.Type, on object: Any, location: [PathSegment] = []) -> [Value] {
        Mirror(reflecting: object).children.enumerated().flatMap { (index, child) -> [Value] in
            let segment = child.label.map { PathSegment.label($0) } ?? PathSegment.index(index)
            let location = location + [segment]
            var newValues: [Value] = []

            if child.value is P {
                newValues.append(Value(type: type(of: child.value), location: location))
            }

            newValues.append(contentsOf: values(matching: predicate, on: child.value, location: location))

            return newValues
        }
    }

    enum SetError: Error {
        case castToArray
        case arrayLength
        case createTypeInfo
        case createPropertyInfo
        case setPropertyValue
        case incorrectTypeAtBaseCase
    }

    /// - Note: Cannot yet set using `index` path segment option on arrays which are declared using
    ///   a protocol.
    /// - Unfortunately this means we currently don’t support indexing an array of models `[Model]`
    ///
    static func setValue<T>(at location: [PathSegment], to value: Any, on object: inout T) throws {
        object = try performSetValue(at: location, to: value, on: object)
    }

    private static func performSetValue<T>(at location: [PathSegment], to value: Any, on object: T) throws -> T {
        var object = object

        guard let currentSegment = location.first else {
            if let value = value as? T {
                return value
            } else {
                throw SetError.incorrectTypeAtBaseCase
            }
        }

        let nextLocation = Array(location.suffix(location.count - 1))

        switch currentSegment {

        case .index(let index):
            guard var array = object as? [Any] else {
                throw SetError.castToArray
            }

            guard index < array.count else {
                throw SetError.arrayLength
            }

            func cast<V>(val: Any, to valueType: V) -> V {
                val as! V
            }

            array[index] = try performSetValue(at: nextLocation, to: value, on: array[index])
            object = array as! T

        case .label(let label):
            let tInfo: TypeInfo

            do {
                tInfo = try typeInfo(of: type(of: object as Any))
            } catch let error {
                dump(error)
                throw SetError.createTypeInfo
            }

            assert(tInfo.properties.contains(where: { $0.name == label }), "Property not found for label")

            let pInfo: PropertyInfo

            do {
                pInfo = try tInfo.property(named: label)
            } catch {
                throw SetError.createPropertyInfo
            }

            do {
                let existingObject = getValue(at: [currentSegment], on: object)!
                let newObject = try performSetValue(at: nextLocation, to: value, on: existingObject)
                try pInfo.set(value: newObject, on: &object)
            } catch let error {
                dump(error)
                throw SetError.setPropertyValue
            }

        }

        return object
    }

    static func getValue(at location: [PathSegment], on object: Any) -> Any? {
        if location.isEmpty {
            return object
        }

        var object = object

        for segment in location {
            switch segment {

            case .index(let index):
                guard let array = object as? [Any] else {
                    return nil
                }

                guard index < array.count else {
                    return nil
                }

                object = array[index]

            case .label(let label):
                let mirror = Mirror(reflecting: object)

                guard let value = mirror.descendant(label) else {
                    return nil
                }

                object = value
            }
        }

        return object
    }


}

extension ObjectPathFinder.Value: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.type == rhs.type
            && lhs.location == rhs.location
    }
}


//extension Property.PathSegment: Equatable {
//    static func ==(lhs: Self, rhs: Self) -> Bool {
//        return lhs.type == rhs.type
//            && lhs.location == rhs.location
//    }
//}
