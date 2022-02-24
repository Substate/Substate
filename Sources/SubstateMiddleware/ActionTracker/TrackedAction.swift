public protocol TrackedAction {

    /// An name suitable for sending to an analytics backend.
    ///
    var trackingName: String { get }

    /// A metadata payload suitable for sending to an analytics backend.
    ///
    var trackingMetadata: [String:Any] { get }

    /// TODO: New property-based API
    // var trackingProperties: [TrackedProperty] { get }

}

public extension TrackedAction {

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

// TODO: Flesh out the below concept.
//import Substate
//import Foundation
//
//public struct TrackedProperty {
//    static func value<T:Model, V:Any>(_ keyPath: KeyPath<T, V>) -> TrackedProperty { fatalError() }
//    static func model<T:Model>(_ type: T.Type) -> TrackedProperty { fatalError() }
//    static func constant(_ name: String, value: Any) -> TrackedProperty { fatalError() }
//    static func value<A:Action, V:Any>(_ keyPath: KeyPath<A, V>) -> TrackedProperty { fatalError() }
//    static func action() -> TrackedProperty { fatalError() }
//}
//
//struct ProfileDidLoad: Action {}
//struct ProfileWasSaved: Action {
//    let success: Bool
//}
//
//struct Usage: Model {
//    var deviceName: String
//    var launchCount: Int
//    mutating func update(action: Action) {}
//}
//
//struct Audio: Model {
//    var outputVolume: Double
//    mutating func update(action: Action) {}
//}
//
// Tracking
//
//let analyticsTriggers = ActionTriggers {
//    let service = AnalyticsService()
//
//    ActionTracker.Event
//        .perform { service.track(event: $0.name, properties: $0.properties) }
//}
//
//extension ProfileDidLoad: TrackedAction {
//    var trackingProperties: [TrackedProperty] {[
//        .action(),
//        .constant("duration", value: 1)
//    ]}
//}
//
//extension ProfileWasSaved: TrackedAction {
//    var trackingProperties: [TrackedProperty] {[
//        .value(\Self.success),
//        .value(\Usage.deviceName),
//        .value(\Usage.launchCount),
//        .constant("screen", value: "home"),
//        .constant("highScore", value: 123),
//    ]}
//}

//extension OutputVolumeDidChange: TrackedAction {
//    var eventProperties: [EventProperty] {[
//        .value(\Self.volume),
//        .value(\Audio.headphonesAreConnected),
//        .constant("deviceType", UIDevice.current.name)
//    ]}
//}
