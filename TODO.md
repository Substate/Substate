# Store

- Need to traverse updates from deepest to shallowest so that parents can read the up-to-date state from all of their children
  - Think this is done but needs to be tested properly!

- Make the store not conform to ObservableObject so users can’t pass it as to .environmentObject() directly
  - To be able to prevent crashes due to a missing store, we want control over its passing in to the view hierarchy
  - Can probably use some wrapper type that binds to the store and conforms to ObservableObject and is used by the .store() and .state() wrappers
  - Might be able to overload .environmentObject(Substate.Store) and provide an Xcode error message to explain why it’s deprecated/not possible?

- Optimise state selection by computing a full tree on init
- Provide some kind of helper on the store to create bindings for SwiftUI that take a setter action
  - Could this actually be done within the `State`s with property wrappers or something so that the view is super clean?
  - ie. view call site would just look like Toggle(value: counter.$isActive)
  - Somewhere else you would link Counter.isActive and Counter.SetActive(Bool) to create the binding
  - Might be possible to use property wrappers and generics to link a struct (action) with a single init param and the variable you want the binding for?
  - eg. @AutoBinding(SetActive.self) var isActive: Bool = false
  - Otherwise, a list of mappings elsewhere? Add the $ properties dynamically with dynamic method dispatch?
  - Tag actions? eg. struct SetActive: Action, SetterAction { let setterKeyPath = \Counter.isActive }
  - Auto binding for a sub-state as a whole?
    eg. struct MyComponent: State, AutoBindingState { let setter: ... }
    too coarse-grained? Provide map of bindable props? { bindableList = [\.isActive : SetActive.self, ...] }
- Remove dependency on the Runtime library
- Add an `oldValue` property to the `Replace` store action so models can observe changes if they want
- Is there any possible way to get a nice `Replace<MyModel>` generic type?

# Middleware

- Effects system? At present it’s cumbersome to hook up service dependencies to receive and return actions.
    - Maybe keep the API here super simple on purpose to force all mapping/referencing of model state through ActionTrigger
    - Otherwise this could just become a version of ActionTrigger that duplicates all the same functionality and is really easy to abuse
    - May need to think carefully about naming: `trigger()` may be out if we want to extend `Action` like this 
```
protocol Service {
    var effects: Effects { get }
}

extension AudioRecorder: Service {

    struct Start: Action {}
    struct Started: Action {}

    struct Stop: Action {}
    struct Stopped: Action {}

    struct ReceivedBuffer {
        let buffer: AVAudioPCMBuffer
        let time: AVAudioTime
    }
    
    struct State: Model {
        var isRecording: Bool = false
        
        mutating func update(action: Action) {
            switch action {
            case is AudioRecorder.Started: isRecording = true
            case is AudioRecorder.Stopped: isRecording = false
            default: ()
            }
        }
    }
   
    var model: Model = State()

    var effects: Effects {
        Start
            .trigger(start)
            .success(Started.init)
            .failure(Failed.init)

        Stop
            .trigger(stop)
            .success(Stopped.init)

        buffersAsyncStream
            .trigger(ReceivedBuffer.init)

        buffersCombinePublisher
            .trigger(ReceivedBuffer.init)
    }

}
```

- Add ActionDebouncer and ActionThrottler into ActionDelayer and make it one middleware. Call it something like ActionTimer.

- Expand StateLogger to show smart diffs, eg:
  ▿ Substate.State
    - Settings.appearance.tint { "green" → "orange" }
    - Settings.appearance.theme { "midnight" → "sunbeam" }

- Expand loggers
  - More formatting options, show timestamp etc
  - Allow a predicate to select items to log?
  - Probably provide a whole configuration struct like trigger

- Undo manager!
  - Tag actions as undoable
  - Different undo contexts (also specified on the actions)

- Could have some kind of migration logic available to the StateSaver
  - eg. MyState: State, SavedState, MigratedState { let usedToBe: OtherState }
  - Or a VersionedState? With something like func migrate(from oldVersion: StateVersion, to newVersion: StateVersion) -> Self

- Simple start/finish action identifier?
pass a start action type and end action type
identify runs either by time or by ID, eg track RequestDidStart {} / RequestDidComplete { let value }
transform start + end into a new action
could this be done cleanly with tagging, or do we need a whole setup procedure?
naming? ActionPairTracker?
is this just a group tracker with 2 steps?

- Tracker for multiple actions that comprise an activity
triggers a completion event if certain actions are recognised
could take into account ordering?
naming? ActionGroupTracker?

- JourneyTracker
Track user journeys
Track a series of steps with timings
Probably want to reduce a value at the end, dispatch something like JourneyTracker.JourneyDidComplete<Output>
Don’t need a concept of success/fail, that can be encoded by the user in terms of what value they reduce to
is this just the same as the above?

    struct WidgetFetchButtonWasPressed: Action, JourneyAction {
        let journey = WidgetFetchingJourney.self
        let journeyOrder = 1
    }

    struct FetchWidgets: Action, JourneyAction {
        let journey = WidgetFetchingJourney.self
        let journeyOrder = 2
    }

    struct FetchWidgetsDidSucceed: Action, JourneyAction {
        let journey = WidgetFetchingJourney.self
        let journeyOrder = 3
    }

Not sure if this will really work as a tagging exercise. Who does the final reduce? What about actions that are part of multiple journeys? But would be cool if it can work.

Alt:

    struct Journey<A1, A2, A3, Output> where A1: Action, A2: Action, A3: Action, Output: Action {
        struct ActionMeta<T:Action> { let time: Date, value: T }
        init(_ a1: A1.Type, _ a2: A2.Type, _ a3: A3.Type, reduce: (ActionMeta<A1>, ActionMeta<A2>, ActionMeta<A3>) -> Output) {
            // Cache reducer and use later
        }
    }

```swift
let journey = Journey(ButtonWasTapped.self, Fetch.self, FetchDidSucceed.self) { tap, fetch, succeed in
    JourneyDidComplete (
        buttonTaps: tap.count,
        totalTime: succeed.time.timeIntervalSince(tap.time),
        fetchTime: succeed.time.timeIntervalSince(fetch.time),
        itemsFetched: succeed.value.items.count
    )
}
```

Would need more metadata on the action triggers to be really powerful:
- how many times each action was fired, if multiple
- what constitutes cancelling the journey? Too many fires of an action? Some other action? eg. FetchWidgetsScreenDismissed
- possible to fit all that in without blowing the API out too much?
- Simple (a1, a2, ... aN) init for basic case, and another one where each arg is a config object with all the extra settings for each step?

let step = Journey.Step(
    action: WidgetFetchButtonWasPressed.self,
    validator: { a in a.foo = bar },
    minOccurances: 1,
    maxOccurances: .infinity,
    // Optional doesn’t affect completion but makes the action available to the reducer
    type: {.required, .optional, .mustNotOccur}
    ordering: {.exact, .thisPositionOrEarlier, .thisPositionOrLater, .any}
)

- Middleware could optionally fire off intermediate events
  - eg. JourneyTracker.JourneyDidProgress
    - journey: how to ID this?
    - step: WidgetFetchButtonWasPressed

# UI

- TextView.onSubmit(send: Model.TextWasSubmitted(text: string))
- Some way to automatically tap changes in environment values to get nice clean ActionTriggers?
  - Eg. automatically send a ScenePhase.Changed(oldValue: ScenePhase, newValue: ScenePhase) action
  - How to register for these events though? There would be loads.
  - Another middleware, providing events from SwiftUI environment values with opt-in?

# Logging

- Comprehensive and library-appropriate internal logging (for internal store stuff, maybe disabled or quiet by default)
- Some kind of general logging helper. Looks like all middlewares are doing some kind of logging, not just the action/state loggers, so it would be good to give it a consistent format.

# Documentation

- Emphasise that you can easily save only some parts of the state to disk
  - So you can continue to churn heavily on the structure of your app state, and keep a few sub-states stable/additive for longer term persistence without constant migration logic
