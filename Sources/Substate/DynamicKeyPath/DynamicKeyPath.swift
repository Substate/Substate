/// A model of a property on any struct or class.
///
/// This is a very janky, limited, unperformant, and buggy attempt to provide something like a
/// WritableKeyPath at runtime using reflection, in order to find `Model`s in the state tree and
/// mutate them. The moment Swift supports getting keypaths at runtime, we’ll rip this out.
///
///     let allNames = DynamicKeyPath<String>.all(on: person)
///     let janesName = DynamicKeyPath<String>(path: .label("jane"), .label("name"))
///
///     DynamicKeyPath<String>(path: .label("name")).get(on: person)
///     DynamicKeyPath<String>(path: .label("name")).set(to: "Jane", on: &person)
///
/// Stores an `Any.Type` in addition to the generic value type so that we can use this construct
/// with runtime values for which we have no static information. Eg:
///
///     let dynamicProperty = Property<Any>(matching: type(of: aChild), path: ...)
///     let dynamicProperties = Property<Any>.all(matching: type(of: aChild), on: aParent)
///
struct DynamicKeyPath<Value> {
    let type: Any.Type
    let path: [DynamicKeyPathSegment]

    init(path: [DynamicKeyPathSegment]) {
        self.type = Value.self
        self.path = path
    }

    init(matching type: Any.Type, path: [DynamicKeyPathSegment]) {
        self.type = type
        self.path = path
    }

    init(path: DynamicKeyPathSegment...) {
        self.init(path: path)
    }

    init(matching type: Any.Type, path: DynamicKeyPathSegment...) {
        self.init(matching: type, path: path)
    }
}

enum DynamicKeyPathSegment: Equatable {
    case index(Int)
    case label(String)
}

extension DynamicKeyPath: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.type == rhs.type && lhs.path == rhs.path
    }
}

extension DynamicKeyPathSegment: CustomStringConvertible {
    public var description: String {
        switch self {
        case .index(let value): return "\(value)"
        case .label(let value): return "\(value)"
        }
    }
}

extension DynamicKeyPath: CustomStringConvertible {
    public var description: String {
        let path = path.map(String.init(describing:)).joined(separator: " › ")
        return "Substate.DynamicKeyPath<\(String(describing: Value.self))>(type: \(type.self), path: [\(path)])"
    }
}
