import Substate

extension ActionLogger {

    /// Select `ActionLogger.State` from your application to see the logger’s current state.
    ///
    /// ```swift
    /// struct DebugView: View {
    ///     var body: some View {
    ///         Select(ActionLogger.State.self) { logger, update in
    ///             Text("Action logging is: \(logger.isActive ? "Active" : "Inactive")")
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// TODO: Different naming for these internal states? It’s confusing. The word 'state' is
    /// everywhere!
    ///
    public struct Model: Substate.Model {
        public var isActive = false

        public mutating func update(action: Action) {
            switch action {
            case is Start: isActive = true
            case is Stop: isActive = false
            case is Toggle: isActive.toggle()
            default: ()
            }
        }
    }

}
