import AVFoundation

class SoundPlayer {

    var ids: [SystemSoundID]
    var isEnabled = false

    init() {
        ids = .init(repeating: SystemSoundID(), count: Sound.allCases.count)

        Sound.allCases.enumerated().forEach { index, sound in
            guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "wav") else {
                fatalError("Couldn’t find sound file")
            }

            AudioServicesCreateSystemSoundID(url as CFURL, &ids[index])
        }
    }

    func play(_ sound: Sound) {
        guard isEnabled else { return }

        Sound.allCases.firstIndex(of: sound).map {
            AudioServicesPlaySystemSound(ids[$0])
        }
    }

    deinit {
        Sound.allCases.indices.forEach {
            AudioServicesDisposeSystemSoundID(ids[$0])
        }
    }

}
