import SwiftUI

extension Theme {

    var name: String {
        switch self {
        case .sunrise: return "Sunrise"
        case .midnight: return "Midnight"
        case .neon: return "Neon"
        }
    }

    var colorScheme: ColorScheme {
        switch self {
        case .sunrise: return .light
        case .midnight: return .dark
        case .neon: return .dark
        }
    }

    var primaryColour: Color {
        switch self {
        case .sunrise: return .orange
        case .midnight: return .purple
        case .neon: return .yellow
        }
    }

}
