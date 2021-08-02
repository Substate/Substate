import Substate

extension ActionLogger {

    /// Dispatch `LoggedAction.Start` from anywhere in your application to start logging actions.
    ///
    /// ```swift
    /// store.update(ActionLogger.Start())
    /// ```
    ///
    public struct Start: Action {
        public init() {}
    }

    /// Dispatch `LoggedAction.Stop` from anywhere in your application to stop logging actions.
    ///
    /// ```swift
    /// store.update(ActionLogger.Stop())
    /// ```
    ///
    public struct Stop: Action {
        public init() {}
    }

    /// Dispatch `LoggedAction.Toggle` from anywhere in your application to toggle action logging.
    ///
    /// ```swift
    /// store.update(ActionLogger.Toggle())
    /// ```
    ///
    public struct Toggle: Action {
        public init() {}
    }

}
