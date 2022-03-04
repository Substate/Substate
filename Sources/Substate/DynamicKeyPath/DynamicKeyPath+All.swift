extension DynamicKeyPath {

    static func all<Object>(on object: Object, at subpath: [DynamicKeyPathSegment] = []) -> [Self] {
        all(matching: Value.self, on: object)
    }

    static func all<Object>(matching filter: Any.Type, on object: Object, at subpath: [DynamicKeyPathSegment] = []) -> [Self] {
        return Mirror(reflecting: object).children.enumerated().flatMap { (index, child) -> [DynamicKeyPath] in
            let segment = child.label.map { DynamicKeyPathSegment.label($0) } ?? DynamicKeyPathSegment.index(index)
            let subpath = subpath + [segment]
            var newValues: [DynamicKeyPath] = []

            if child.value is Value {
                newValues.append(DynamicKeyPath<Value>(matching: Swift.type(of: child.value), path: subpath))
            }

            newValues.append(contentsOf: all(matching: filter, on: child.value, at: subpath))

            return newValues
        }
    }

}
