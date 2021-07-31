import Foundation

struct Event: Identifiable, Equatable {
    let id: UUID
    let date: Date
    let type: String // For now, later: enum
    let components: [String] // For now, later: something else
}

extension Event {
    static let sample = Event(
        id: .init(),
        date: .init(),
        type: "Action",
        components: ["Foo", "Bar", "Baz", "Qux"]
    )
}
