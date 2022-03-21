import Substate

extension ValueTracker {

    /// A tracking event suitable for uploading to an analytics service.
    ///
    public struct Event: Action {
        public var name: String
        public var value: Any
    }

}
