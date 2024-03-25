import SwiftUI
import Combine

/// A view model class responsible for managing and persisting user settings related to sound and speech recognition features.
/// This class encapsulates the logic for enabling/disabling speech and sound recognition and adjusting relevant settings,
/// with changes persistently stored in `UserDefaults`.
///
/// - Author: Hussein El-Zein
@Observable
class SoundSettingsViewModel {
    var speechRecognitionEnabled: Bool {
        didSet {
            UserDefaults.standard.set(speechRecognitionEnabled, forKey: "speechRecognitionEnabled")
        }
    }
    
    var numberOfWords: Double {
        didSet {
            UserDefaults.standard.set(numberOfWords, forKey: "numberOfWords")
        }
    }
    
    var soundRecognitionEnabled: Bool {
        didSet {
            UserDefaults.standard.set(soundRecognitionEnabled, forKey: "soundRecognitionEnabled")
        }
    }
    
    func resetNumberOfWords(){
        withAnimation {
            numberOfWords = 28.0
        }
    }
    
    init() {
        self.speechRecognitionEnabled = UserDefaults.standard.object(forKey: "speechRecognitionEnabled") as? Bool ?? true
        self.numberOfWords = UserDefaults.standard.object(forKey: "numberOfWords") as? Double ?? 26.0
        self.soundRecognitionEnabled = UserDefaults.standard.object(forKey: "soundRecognitionEnabled") as? Bool ?? true
    }
}
