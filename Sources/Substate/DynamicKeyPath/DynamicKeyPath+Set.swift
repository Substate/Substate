import Runtime

extension DynamicKeyPath {

    enum SetError: Error {
        case castToArray
        case arrayLength
        case createTypeInfo
        case createPropertyInfo
        case getPropertyValue
        case setPropertyValue
        case incorrectTypeAtBaseCase
    }

    /// - Note: Cannot yet set using `index` path segment option on arrays where we don’t have the
    ///   compile-time type of the array, so for now we only operate on arrays of type [Model].
    ///
    func set<Object>(to value: Value, on object: inout Object) throws {
        object = try set(value: value, at: self.path, on: object)
    }

    private func set<Object>(value: Any, at path: [DynamicKeyPathSegment], on object: Object) throws -> Object {
        var object = object
        
        guard let currentSegment = path.first else {
            if let value = value as? Object {
                return value
            } else {
                throw SetError.incorrectTypeAtBaseCase
            }
        }

        let nextLocation = Array(path.suffix(path.count - 1))

        switch currentSegment {

        case .index(let index):
            guard var array = object as? [Model] else {
                // THIS IS THE ERROR THAT WILL FIRE IF WE ENCOUNTER A NON- [Model] array
                // We could warn about this on first init of the store.
                throw SetError.castToArray
            }

            guard index < array.count else {
                throw SetError.arrayLength
            }

            array[index] = try set(value: value, at: nextLocation, on: array[index])
            object = array as! Object

        case .label(let label):
            let tInfo: TypeInfo

            do {
                tInfo = try typeInfo(of: Swift.type(of: object as Any))
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

            guard let existingObject = DynamicKeyPath<Any>(path: currentSegment).get(on: object) else {
                throw SetError.getPropertyValue
            }

            do {
                let newObject = try set(value: value, at: nextLocation, on: existingObject)
                try pInfo.set(value: newObject, on: &object)
            } catch let error {
                dump(error)
                throw SetError.setPropertyValue
            }

        }

        return object
    }

}
