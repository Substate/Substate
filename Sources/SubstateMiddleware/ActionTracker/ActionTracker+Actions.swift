import Substate

extension ActionTracker {

    public struct Event: Action {
        public let action: TrackedAction
    }

}
