import Substate

enum Sound {

    case blip, trash, pong

    struct Play: Action {
        let sound: Sound
        init(_ sound: Sound) { self.sound = sound }
    }

}
