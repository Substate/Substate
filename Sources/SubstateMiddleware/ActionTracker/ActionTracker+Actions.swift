import Substate

extension ActionTracker {

    public struct Event: Action {
        // TODO: Add something like the below that can be consumed to send events to a backend.
        //
        // private var resolvedPropertyValues: [ResolvedTrackedProperty] = [] // To be filled by middleware.
        //
        // public var name: String
        // public var properties: [String:Any] { ... } // Potentially computed from resolvedPropertyValues

        // TODO: Not sure we really need to include this? Just send the calculated values.
        public let action: TrackedAction
    }

}
