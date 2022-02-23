/// A model of a property on any struct or class.
///
/// Stores an `Any.Type` in addition to the generic value type so that we can use this construct
/// with runtime values for which we have no static information. Eg:
///
///     let dynamicProperty = Property<Any>(matching: type(of: aChild), path: ...)
///     let dynamicProperties = Property<Any>.all(matching: type(of: aChild), on: aParent)
///
struct Property<Value> {
    let type: Any.Type
    let path: [PropertyPathSegment]

    init(path: [PropertyPathSegment]) {
        self.type = Value.self
        self.path = path
    }

    init(matching type: Any.Type, path: [PropertyPathSegment]) {
        self.type = type
        self.path = path
    }

    init(path: PropertyPathSegment...) {
        self.init(path: path)
    }

    init(matching type: Any.Type, path: PropertyPathSegment...) {
        self.init(matching: type, path: path)
    }

}

enum PropertyPathSegment: Equatable {
    case index(Int)
    case label(String)
}

extension Property: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.type == rhs.type && lhs.path == rhs.path
    }
}

extension PropertyPathSegment: CustomStringConvertible {
    public var description: String {
        switch self {
        case .index(let value): return "\(value)"
        case .label(let value): return "\(value)"
        }
    }
}

extension Property: CustomStringConvertible {
    public var description: String {
        let path = path.map(String.init(describing:)).joined(separator: " › ")
        return "Substate.Property<\(String(describing: Value.self))>(type: \(type.self), path: [\(path)])"
    }
}
