import Substate

extension ActionTracker {

    /// A tracking event suitable for uploading to an analytics service.
    ///
    /// - We mark this as sendable, because we only expect to store primitives in `value`. It is an
    ///   error to put anything non-thread-safe in the value.
    ///
    public struct Event: Action, @unchecked Sendable {
        public var name: String
        public var values: [String:Any]
    }

}
