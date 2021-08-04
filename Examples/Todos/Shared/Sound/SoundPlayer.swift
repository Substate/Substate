import AVFoundation

class SoundPlayer {

    var ids: [SystemSoundID]

    init() {
        ids = .init(repeating: SystemSoundID(), count: Sound.allCases.count)
        
        Sound.allCases.enumerated().forEach { index, sound in
            guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "wav") else {
                fatalError("Couldn’t find sound file")
            }

            let cfurl = url as CFURL
            AudioServicesCreateSystemSoundID(cfurl, &ids[index])
        }
    }

    func play(_ sound: Sound) {
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
