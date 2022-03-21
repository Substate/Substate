import Substate

/// Watch a list of values for changes and produce a payload suitable for analytics tracking.
///
/// Usage:
///
/// ```swift
/// let values: TrackedValues = [
///     "User.id": .model(\User.id),
///     "Usage.launchCount": .model(\Usage.launchCount),
///     "Device.name": UIDevice.current.name
/// ]
///
/// let tracker = ValueTracker(values: values)
/// ```
///
/// Usage with ActionTriggers:
///
/// ```swift
/// let appTriggers = ActionTriggers {
///     let analytics = AnalyticsService()
///
///     ValueTracker.Event
///         .perform { analytics.track(property: $0.name, value: $0.value) }
/// }
/// ```
///
public class ValueTracker: Middleware {

    var values: [(name: String, resolve: (Action, Find) async -> AnyHashable?, value: AnyHashable?)] = []

    public init(values: TrackedValues) {
        self.values = values.map { (name: $0.0, resolve: $0.1.resolve, value: nil) }
    }

    public func configure(store: Store) -> (@escaping DispatchFunction) -> DispatchFunction {
        { next in
            { action in
                try await next(action)

                if action is Event {
                    return
                }

                for (index, item) in self.values.enumerated() {
                    if let new = await item.resolve(action, store.find), new != item.value {
                        try await store.dispatch(Event(name: item.name, value: new))
                        self.values[index].value = new
                    }
                }

            }
        }
    }

}
