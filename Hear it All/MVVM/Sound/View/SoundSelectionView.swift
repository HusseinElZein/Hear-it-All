import SwiftUI

/// A view for selecting the sounds to be recognized by the application.
/// Users can search for and select various sounds from the provided list, which updates the `SoundRecognizer` view model with the user's selections.
///
/// - Author: Hussein El-Zein
struct SoundsSelectionView: View {
    @ObservedObject var soundRecognizer: SoundRecognizer
    let availableSounds: [String]
    @State var search = ""
    
    private var filteredSounds: [String] {
        if search.isEmpty {
            return availableSounds
        } else {
            return availableSounds.filter { $0.lowercased().contains(search.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List(filteredSounds, id: \.self) { sound in
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
                        Text(sound.replacing("_", with: " "))
                    }.tint(.green)
                }
                .scrollContentBackground(.hidden)
                .background(Color.backgroundColor)
            }.navigationTitle(Localized.SoundsLocalized.choose_sounds)
                .navigationBarItems(trailing: Button(action: toggleAllSounds) {
                    Text(toggleButtonText)
                })
        }.searchable(text: $search, prompt: Localized.SoundsLocalized.search_sounds)
    }
}

extension SoundsSelectionView {
    private var areAllSoundsSelected: Bool {
        Set(availableSounds).subtracting(soundRecognizer.userSelectedSounds).isEmpty
    }
    
    private var toggleButtonText: String {
        areAllSoundsSelected ? Localized.SoundsLocalized.all_off : Localized.SoundsLocalized.all_on
    }
    
    private func toggleAllSounds() {
        if areAllSoundsSelected {
            soundRecognizer.userSelectedSounds.removeAll()
        } else {
            soundRecognizer.userSelectedSounds = Set(availableSounds)
        }
        soundRecognizer.saveSelectedSounds()
    }
}

extension SoundRecognizer {
    func saveSelectedSounds() {
        UserDefaults.standard.set(Array(userSelectedSounds), forKey: "UserSelectedSounds")
    }
}
