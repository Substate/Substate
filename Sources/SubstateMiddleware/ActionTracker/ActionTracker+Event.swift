import Substate

extension ActionTracker {

    /// A tracking event suitable for uploading to an analytics service.
    ///
    public struct Event: Action {
        public var name: String
        public var values: [String:Any]
    }

}
