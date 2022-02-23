protocol TrackedAction {

    /// An name suitable for sending to an analytics backend.
    ///
    var trackingName: String { get }

    /// A metadata payload suitable for sending to an analytics backend.
    ///
    var trackingMetadata: [String:Any] { get }

}

extension TrackedAction {

    /// Provides a default tracking name for the action based on type information.
    ///
    /// - Eg. MyApp.OnboardingScreen.NextButtonWasTapped
    ///
    var trackingName: String {
        String(reflecting: Self.self)
    }

    /// Provides a default metadata dictionary for the action, just containing its name.
    ///
    var trackingMetadata: [String:Any] {
        ["action": trackingName]
    }

}
