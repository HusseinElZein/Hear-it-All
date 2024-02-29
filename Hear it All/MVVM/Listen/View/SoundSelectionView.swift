import SwiftUI

struct SoundsSelectionView: View {
    @ObservedObject var soundRecognizer: SoundRecognizer
    let availableSounds: [String]
    
    var body: some View {
        List(availableSounds, id: \.self) { sound in
            Toggle(isOn: Binding(
                get: { self.soundRecognizer.userSelectedSounds.contains(sound) },
                set: { isSelected in
                    if isSelected {
                        self.soundRecognizer.userSelectedSounds.insert(sound)
                    } else {
                        self.soundRecognizer.userSelectedSounds.remove(sound)
                    }
                }
            )) {
                Text(sound)
            }
        }
    }
}
