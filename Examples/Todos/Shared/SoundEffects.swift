import Substate

enum SoundEffects {

    enum Effect {
        case blip, trash, pong
    }

    struct Play: Action {
        let effect: Effect
        init(_ effect: Effect) { self.effect = effect }
    }

}
