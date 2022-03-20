public protocol TrackedAction {

    /// A name suitable for sending to an analytics backend.
    ///
    static var trackedName: String { get }

    /// A metadata payload of values suitable for sending to an analytics backend.
    ///
    static var trackedValues: TrackedValues { get }

}

public extension TrackedAction {

    /// Provides a default tracking name for the action based on type information.
    ///
    /// - Eg. OnboardingScreen.NextButtonWasTapped
    ///
    static var trackedName: String {
        String(reflecting: self)
            .split(separator: ".")
            .filter { !$0.contains("unknown context at $") }
            .dropFirst()
            .joined(separator: ".")
    }

    /// Provides a default empty list of associated tracked values.
    ///
    static var trackedValues: TrackedValues {
        [:]
    }

}
