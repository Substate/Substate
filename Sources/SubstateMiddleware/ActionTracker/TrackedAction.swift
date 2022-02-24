public protocol TrackedAction {

    /// An name suitable for sending to an analytics backend.
    ///
    var trackingName: String { get }

    /// A metadata payload suitable for sending to an analytics backend.
    ///
    var trackingProperties: [String:Any] { get }

}

public extension TrackedAction {

    /// Provides a default tracking name for the action based on type information.
    ///
    /// - Eg. MyApp.OnboardingScreen.NextButtonWasTapped
    ///
    var trackingName: String {
        String(reflecting: Self.self)
            .split(separator: ".")
            .filter { !$0.contains("unknown context at $") }
            .joined(separator: ".")
    }

    /// Provides a default empty tracking property list.
    ///
    var trackingProperties: [String:Any] {
        [:]
    }

}
