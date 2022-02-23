import Substate

/// Transform tagged actions into a payload suitable for analytics tracking.
///
/// Usage:
///
/// ```swift
/// struct BasicTrackedAction: Action, TrackedAction {}
///
/// struct CustomTrackedAction: Action, TrackedAction {
///     let trackingName: String = "custom-tracking-name"
///     let trackingMetadata: [String:Any] = ["some": "value"]
/// }
/// ```
///
/// Usage with ActionTriggers:
///
/// ```swift
/// let appTriggers = ActionTriggers {
///     let analytics = AnalyticsBackendDependency()
///
///     ActionTracker.Event
///         .perform { analytics.trackEvent(name: $0.name, payload: $0.metadata) }
/// }
/// ```
///
public class ActionTracker: Middleware {

    public init() {}

    public func update(send: @escaping Send, find: @escaping Find) -> (@escaping Send) -> Send {
        return { next in
            return { action in
                if let action = action as? TrackedAction {
                    send(Event(action: action))
                }

                next(action)
            }
        }
    }

}
