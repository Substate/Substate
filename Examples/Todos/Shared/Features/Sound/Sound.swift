import Substate

enum Sound: String, CaseIterable {

    case pop, pow, twinkle, warp, swish, click

    struct Play: Action {
        let sound: Sound

        init(_ sound: Sound) {
            self.sound = sound
        }
    }

}
