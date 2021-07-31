import Substate

struct EventStream: Model {

    var events: [Event] = []

    var groups: [EventGroup] {
        events
            .sorted(by: { $0.date < $1.date })
            .reduce([EventGroup]()) { groups, event in
                if groups.isEmpty {
                    return [EventGroup(events: [event])]
                }

                let latestEvent = groups.last!.events.last!

                if event.date.timeIntervalSince(latestEvent.date) > 1 {
                    return groups + [EventGroup(events: [event])]
                } else {
                    var groups = groups
                    groups[groups.index(before: groups.endIndex)].events.append(event)
                    return groups
                }
            }
    }

    struct Add: Action {
        let event: Event
    }

    struct Clear: Action {}

    mutating func update(action: Action) {
        switch action {

        case let action as Add:
            events.append(action.event)

        case is Clear:
            events.removeAll()

        default: ()
        }
    }

}

extension EventStream {
    static let sample = EventStream(events: [
        .sample, .sample, .sample
    ])
}
