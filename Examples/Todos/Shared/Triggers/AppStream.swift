import Substate
import SubstateMiddleware
import CombineExt

/// ActionStreams API Playground
///
@MainActor let appStream = ActionStream { stream in

    // Set up player

    let player = SoundPlayer()

    (\Settings.sounds)
        .subscribe(on: stream)
        .sink { player.isEnabled = $0 }

    Sound.Play
        .subscribe(on: stream)
        .sink { player.play($0.sound) }

    //

    Settings.VolumeSliderDidChange
        .subscribe(on: stream)
        .map { ($0.volume * 1000).rounded() / 1000 }
        .removeDuplicates()
        .throttle(for: .milliseconds(100), scheduler: RunLoop.main, latest: true)
        .removeDuplicates()
        .map { Settings.SetVolume(volume: $0) }
        .eraseToAnyPublisher()



    // Trigger sounds

    Tabs.Select
        .subscribe(on: stream)
        .map { Sound.Play(.click) }
        .eraseToAnyPublisher()

    CreateTaskScreenModel.Toggle
        .subscribe(on: stream)
        .map { Sound.Play($0.isActive ? .pop : .swish) }
        .eraseToAnyPublisher()



//    // Notifications
//
//    Tasks.Create
//        .subscribe(on: stream)
//        .map { Notifications.Show(message: .taskCreated) }
//        .eraseToAnyPublisher()
//
//    Tasks.Delete
//        .subscribe(on: stream)
//        .map { Notifications.Show(message: .taskDeleted) }
//        .eraseToAnyPublisher()


}


/// Could be a good pattern for dependencies to describe how they’re hooked up to state and actions.
///
@MainActor class SomeDependency {

    let player = SoundPlayer()

    var streams: ActionStream {
        .init { stream in

            (\Settings.sounds)
                .subscribe(on: stream)
                .sink { self.player.isEnabled = $0 }

            Sound.Play
                .subscribe(on: stream)
                .sink { self.player.play($0.sound) }

        }
    }

}
