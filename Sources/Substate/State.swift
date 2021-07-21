public protocol State {
    mutating func update(action: Action)
}

typealias StateArray = [State]

extension StateArray: State {
    public mutating func update(action: Action) {
        indices.forEach { self[$0].update(action: action) }
    }
}
