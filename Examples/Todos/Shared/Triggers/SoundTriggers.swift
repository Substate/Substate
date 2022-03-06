import Substate
import SubstateMiddleware

let soundTriggers = ActionTriggers {

    Tabs.Select.trigger(Sound.Play(.click))

    Settings.SetTheme.trigger(Sound.Play(.click))
    Settings.SetSounds.trigger(Sound.Play(.click))
    Settings.SetColourScheme.trigger(Sound.Play(.click))

    Tasks.Create.trigger(Sound.Play(.twinkle))
    Tasks.Delete.trigger(Sound.Play(.warp))
    Tasks.Toggle.trigger(Sound.Play(.pow)) // switch on state! More elegant API!

    Toolbar.AddButtonWasPressed.trigger(Sound.Play(.pop))

    Notifications.Dismiss.trigger(Sound.Play(.swish))

    // This is not well factored! Should be more like add button pressed on TasksScreen
    // and dismissed on add screen.
    CreateTaskScreenModel.Toggle.trigger {
        toggle in Sound.Play(toggle.isActive ? .pop : .swish)
    }

    let player = SoundPlayer()

    Sound.Play
        .perform { player.play($0.sound) }

}
