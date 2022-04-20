import SwiftUI
import SubstateUI

struct SettingsScreen: View {

    @Value(\Settings.theme, Settings.SetTheme.init) var theme
    @Value(\Settings.sounds, Settings.SetSounds.init) var sounds
    @Value(\Settings.volume, Settings.VolumeSliderDidChange.init) var volume
    @Value(\Settings.colourScheme, Settings.SetColourScheme.init) var colourScheme

    @Value(\Settings.autoDismissNotifications, Settings.SetAutoDismissNotifications.init)
    var autoDismissNotifications

    @Model(Settings.Update.init) var settings // Interesting ?

    var body: some View {
        NavigationView {
            Form {
                appearanceSection
                notificationsSection
                savingSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    var appearanceSection: some View {
        Section(header: Text("Appearance")) {
            themePicker
            colourSchemeOverridePicker
            soundsToggle
        }
    }

    var themePicker: some View {
        Picker("Theme", selection: $theme) {
            ForEach(Theme.allCases, id: \.self) { theme in
                HStack {
                    Image(systemName: "circle.fill")
                        .foregroundColor(theme.primaryColour)

                    Text(theme.name)
                }
                .tag(theme)
            }
        }
    }

    var colourSchemeOverridePicker: some View {
        Picker("Colour Scheme", selection: $colourScheme) {
            ForEach(Settings.ColourSchemeOverride.allCases, id: \.self) { override in
                Text(override.label)
                    .tag(override)
            }
        }
    }

    var soundsToggle: some View {
        Group {
            Toggle("Sounds", isOn: $sounds)
                .tint(theme.primaryColour)

            Slider(value: $volume, in: 0...1)
        }
    }

    var notificationsSection: some View {
        Section(header: Text("Notifications")) {
            Toggle("Dismiss Automatically", isOn: $autoDismissNotifications)
                .tint(theme.primaryColour)
        }
    }

    var savingSection: some View {
        Section(header: Text("Saving & Loading")) {

        }
    }

}
