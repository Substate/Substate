public protocol State {
    mutating func update(action: Action)
}
