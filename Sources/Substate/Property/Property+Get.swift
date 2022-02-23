extension Property {

    func get<Object>(on object: Object) -> Value? {
        if path.isEmpty {
            return object as? Value
        }

        var value: Any = object

        for segment in path {
            switch segment {

            case .index(let index):
                guard let array = value as? [Any] else {
                    return nil
                }

                guard index < array.count else {
                    return nil
                }

                value = array[index]

            case .label(let label):
                let mirror = Mirror(reflecting: value)

                guard let descendant = mirror.descendant(label) else {
                    return nil
                }

                value = descendant
            }
        }

        return value as? Value
    }

}

