import Foundation

struct EventGroup: Identifiable, Equatable {
    var events: [Event]

    var id: UUID {
        events.first?.id ?? .init()
    }
}
