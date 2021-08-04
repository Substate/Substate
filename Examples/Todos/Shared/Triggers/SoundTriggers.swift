import SubstateMiddleware

let soundTriggers = ActionTriggerList {

    Tasks.Create
        .trigger(Sound.Play(.twinkle))

    Tasks.Delete
        .trigger(Sound.Play(.warp))

    Tasks.Toggle
        .trigger(Sound.Play(.pow))

    Toolbar.AddButtonWasPressed
        .trigger(Sound.Play(.pop))

}
