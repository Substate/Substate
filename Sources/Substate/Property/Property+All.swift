extension Property {

    static func all<Object>(on object: Object, at subpath: [PropertyPathSegment] = []) -> [Self] {
         all(matching: Value.self, on: object)
    }

    static func all<Object>(matching filter: Any.Type, on object: Object, at subpath: [PropertyPathSegment] = []) -> [Self] {
        Mirror(reflecting: object).children.enumerated().flatMap { (index, child) -> [Property] in
            let segment = child.label.map { PropertyPathSegment.label($0) } ?? PropertyPathSegment.index(index)
            let subpath = subpath + [segment]
            var newValues: [Property] = []

            if child.value is Value && Swift.type(of: child.value) == filter {
                newValues.append(Property<Value>(matching: Swift.type(of: child.value), path: subpath))
            }

            newValues.append(contentsOf: all(matching: filter, on: child.value, at: subpath))

            return newValues
        }
    }

}
