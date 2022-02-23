import Runtime

extension Property {

    enum SetError: Error {
        case castToArray
        case arrayLength
        case createTypeInfo
        case createPropertyInfo
        case getPropertyValue
        case setPropertyValue
        case incorrectTypeAtBaseCase
    }

    // TODO: Probably just start again with this.
    // does it really have to be recursive? Can’t we just do a loop and update the objects in place?


    /// - Note: Cannot yet set using `index` path segment option on arrays which are declared using
    ///   a protocol.
    /// - Unfortunately this means we currently don’t support indexing an array of models `[Model]`
    ///
    func set<Object>(to value: Value, on object: inout Object) throws {
        object = try set(value: value, at: self.path, on: object)
    }

    private func set<Object>(value: Any, at path: [PropertyPathSegment], on object: Object) throws -> Object {
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
            guard var array = object as? [Any] else {
                throw SetError.castToArray
            }

            guard index < array.count else {
                throw SetError.arrayLength
            }

            func cast<V>(val: Any, to valueType: V) -> V {
                val as! V
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

            guard let existingObject = Property<Any>(path: currentSegment).get(on: object) else {
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
