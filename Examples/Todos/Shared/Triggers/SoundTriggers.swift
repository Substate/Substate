import Substate
import SubstateMiddleware

@MainActor let soundTriggers = ActionTriggers {

//    Tabs.Select.trigger(Sound.Play(.click))

    Settings.SetTheme.trigger(Sound.Play(.click))
    Settings.SetSounds.trigger(Sound.Play(.click))
    Settings.SetColourScheme.trigger(Sound.Play(.click))

    Tasks.Create.trigger(Sound.Play(.twinkle))
    Tasks.Delete.trigger(Sound.Play(.warp))
    Tasks.Toggle.trigger(Sound.Play(.pow)) // switch on state! More elegant API!

    Toolbar.AddButtonWasPressed.trigger(Sound.Play(.pop))

    Notifications.Dismiss.trigger(Sound.Play(.swish))

}
