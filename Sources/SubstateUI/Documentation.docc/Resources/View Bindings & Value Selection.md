# View Bindings & Value Selection

Substate supports mutation and binding of models from SwiftUI views.

## Overview

If models are mutated from views, they are updated using the catch-all `Store.Replace` action.

```swift
@Model var settings: Settings
...
Button("Update Theme") {
    settings.theme = .midnight // -> Store.Replace
}
```

Choose a specific action to be triggered when a model is mutated:

```swift
@Model(Settings.Update.init) var settings: Settings
...
Button("Update Theme") {
    settings.theme = .midnight // -> Settings.Update
}
```

For finer control, select a specific model value and give it a custom mutate action:

```swift
@Value(\Settings.theme, Settings.SetTheme.init) var theme
@Value(\Settings.sounds, Settings.SetSounds.init) var sounds
@Value(\Settings.colourScheme, Settings.SetColourScheme.init) var colourScheme
```

Bindings work according to the same update rules:

```swift
@Model var settings: Settings
...
Picker("Theme", selection: $settings.theme) {
    ForEach(Theme.allCases, id: \.self) { theme in
        Text(theme.name).tag(theme) // -> Store.Replace
    }
}
```

```swift
@Value(\Settings.theme, Settings.SetTheme.init) var theme
...
Picker("Theme", selection: $theme) {
    ForEach(Theme.allCases, id: \.self) { theme in
        Text(theme.name).tag(theme) // -> Settings.SetTheme
    }
}
```

## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
