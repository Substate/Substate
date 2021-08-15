import Substate
import SubstateMiddleware

protocol CustomSettableModel {
    func setter(_ value: Self) -> Action
    var update: (Self) -> Action { get }
//    var setter: (Self) -> Action { get }
    // Hmmm is there a clean concise way of expressing this requirement? With a property?
    // Problem is a property affects codable conformance.
}

struct Settings: Model, SavedModel, CustomSettableModel {
//    var update: (Settings) -> Action { { Update.init(settings: $0) } }
    let update: (Self) -> Action = Update.init(settings:)
    func update(_ value: Self) -> Action { Update.init(settings: value) }
    func setter(_ value: Self) -> Action { Update.init(settings: value) }

    struct Update: Action, FollowupAction {
        let settings: Settings
        let followup: Action = Changed()
    }

    var sounds = true
    var theme: Theme = .sunrise
    var colourScheme: ColourSchemeOverride = .system
    var autoDismissNotifications = true


    enum ColourSchemeOverride: Int, CaseIterable, Codable {
        case system, theme, light, dark
    }

    // Actions

    struct SetSounds: Action, FollowupAction {
        let sounds: Bool
        let followup: Action = Changed()
    }

    struct SetTheme: Action, FollowupAction {
        let theme: Theme
        let followup: Action = Changed()
    }

    struct SetColourScheme: Action, FollowupAction {
        let scheme: ColourSchemeOverride
        let followup: Action = Changed()
    }

    struct SetAutoDismissNotifications: Action, FollowupAction {
        let isActive: Bool
        let followup: Action = Changed()
    }

    struct Changed: Action {}

    // Update

    mutating func update(action: Action) {
        switch action {

        case let setTheme as SetTheme:
            theme = setTheme.theme

        case let setSounds as SetSounds:
            sounds = setSounds.sounds

        case let setColourScheme as SetColourScheme:
            colourScheme = setColourScheme.scheme

        case let setAutoDismissNotifications as SetAutoDismissNotifications:
            autoDismissNotifications = setAutoDismissNotifications.isActive

        case let update as Update:
            self = update.settings

        default:
            ()
        }
    }

}
