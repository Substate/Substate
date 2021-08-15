import Substate
import SubstateMiddleware

let saveTriggers = ActionTriggerList {

    Tabs.Select.trigger(ModelSaver.Save(Tabs.self))
    Tasks.Changed.trigger(ModelSaver.Save(Tasks.self))
    Settings.Changed.trigger(ModelSaver.Save(Settings.self))

}
