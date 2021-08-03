import Substate

extension ActionLogger {

    /// Use `ActionLogger.Configuration` from your application to see the logger’s current state.
    ///
    /// ```swift
    /// struct DebugView: View {
    ///     @Model var configuration: ActionLogger.Configuration
    ///     var body: some View {
    ///         Text("Action logging is: \(configuration.isActive ? "Active" : "Inactive")")
    ///     }
    /// }
    /// ```
    ///
    public struct Configuration: Model {
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
