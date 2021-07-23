public protocol Model {
    mutating func update(action: Action)
}

typealias ModelArray = [Model]

extension ModelArray: Model {
    public mutating func update(action: Action) {
        indices.forEach { self[$0].update(action: action) }
    }
}
