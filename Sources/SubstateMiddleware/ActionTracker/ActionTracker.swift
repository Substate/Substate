import Substate

/// Transform tagged actions into a payload suitable for analytics tracking.
///
/// Usage:
///
/// ```swift
/// struct RecordingStarted: Action, TrackedAction {}
///
/// struct VolumeChanged: Action, TrackedAction {
///     let volume: Float
///     let trackingName = "volume:changed"
///     let trackingProperties: [String:Any] {[
///         "volume": TrackedValue(\Self.volume),
///         "headphones": TrackedValue(\Audio.headphonesAreActive),
///         "device": UIDevice.current.name
///     ]}
/// }
/// ```
///
/// Usage with ActionTriggers:
///
/// ```swift
/// let appTriggers = ActionTriggers {
///     let analytics = AnalyticsService()
///
///     ActionTracker.Event
///         .perform { analytics.track(event: $0.name, properties: $0.properties) }
/// }
/// ```
///
public class ActionTracker: Middleware {

    public init() {}

    public func configure(store: Store) -> (@escaping DispatchFunction) -> DispatchFunction {
        { next in
            { action in
                if let trackedAction = action as? TrackedAction {
                    var values: [String:Any] = [:]

                    for (key, value) in type(of: trackedAction).trackedValues {
                        values[key] = await value.resolve(action, store.find)
                    }

                    try await store.dispatch(Event(name: type(of: trackedAction).trackedName, values: values))
                }

                try await next(action)
            }
        }
    }

}
