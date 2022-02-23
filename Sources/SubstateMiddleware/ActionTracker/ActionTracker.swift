import Substate

/// Transform tagged actions into a payload suitable for analytics tracking.
///
/// - At present this middleware doesn’t actually need to be included — just tagging actions with
///   `TrackedAction` is sufficient to get some tracking data to use.
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
public class ActionTracker: Middleware {

    public init() {}

    public func update(send: @escaping Send, find: @escaping Find) -> (@escaping Send) -> Send {
        return { next in
            return { action in
                // At present we don’t actually do anything here, as TrackedActions are already
                // easily caught from, for example, the ActionTrigger middleware just using type
                // information. We could add a custom closure to this middleware that is triggered
                // when TrackedActions are seen. Or decorate tracked actions with more metadata,
                // for examply by pulling data from the store according to some new methods defined
                // on TrackedAction.
                next(action)
            }
        }
    }

}
