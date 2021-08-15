import SwiftUI

extension Settings {

    var accentColor: Color {
        theme.primaryColour
    }

    var colorScheme: ColorScheme? {
        switch colourScheme {
        case .system: return nil
        case .theme: return theme.colorScheme
        case .light: return .light
        case .dark: return .dark
        }
    }

}

extension Settings.ColourSchemeOverride {

    var label: String {
        switch self {
        case .system: return "System"
        case .theme: return "Theme"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }

}
