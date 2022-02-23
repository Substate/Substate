extension Property {

    static func all<Object>(on object: Object, at subpath: [PropertyPathSegment] = []) -> [Self] {
         all(matching: Value.self, on: object)
    }

    static func all<Object>(matching filter: Any.Type, on object: Object, at subpath: [PropertyPathSegment] = []) -> [Self] {
        return Mirror(reflecting: object).children.enumerated().flatMap { (index, child) -> [Property] in
            let segment = child.label.map { PropertyPathSegment.label($0) } ?? PropertyPathSegment.index(index)
            let subpath = subpath + [segment]
            var newValues: [Property] = []

            // if child.value is Value && Swift.type(of: child.value) == filter
            // The above doesn’t work with protocols (type(of: child.value) is just the plain type
            // and won’t match if filter is a protocol). It might be we can get away with just the
            // below, and if so we can remove the dynamic filter and associated 'type' property.
            if child.value is Value {
                // newValues.append(Property<Value>(matching: Swift.type(of: child.value), path: subpath))
                // Ditto with the above; if there’s no need to store the type(of:) then great.
                // At least for now, we scope the returned property by the Value requested, whether
                // primitive or a protocol etc.
                newValues.append(Property<Value>(matching: Value.self, path: subpath))
            }

            newValues.append(contentsOf: all(matching: filter, on: child.value, at: subpath))

            return newValues
        }
    }

}
