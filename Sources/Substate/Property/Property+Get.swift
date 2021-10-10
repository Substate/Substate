extension Property {

    func get<Object>(on object: Object) -> Value? {
        // Traverse the given object according to this property’s path, using either a simple array
        // cast to handle index path segments, or `Mirror.descendant` to handle labelled segments.

        if path.isEmpty {
            return object as? Value
        }

        var value: Any = object

        for segment in path {
            switch segment {

            case .index(let index):
                guard let array = object as? [Any] else {
                    return nil
                }

                guard index < array.count else {
                    return nil
                }

                value = array[index]

            case .label(let label):
                let mirror = Mirror(reflecting: object)

                guard let descendant = mirror.descendant(label) else {
                    return nil
                }

                value = descendant
            }
        }

        return value as? Value
    }

}

