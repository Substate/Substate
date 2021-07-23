import SwiftUI

// Environment values that help us detect a missing store environment object before it
// cause a crash.

// TODO: Rename and clean up

private struct SubstateStoreIsPresentEnvironmentKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var substateStoreIsPresent: Bool {
        get { self[SubstateStoreIsPresentEnvironmentKey.self] }
        set { self[SubstateStoreIsPresentEnvironmentKey.self] = newValue }
    }
}
