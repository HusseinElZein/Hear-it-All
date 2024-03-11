import SwiftUI
import Combine

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
    
    init() {
        self.speechRecognitionEnabled = UserDefaults.standard.object(forKey: "speechRecognitionEnabled") as? Bool ?? true
        self.numberOfWords = UserDefaults.standard.object(forKey: "numberOfWords") as? Double ?? 26.0
        self.soundRecognitionEnabled = UserDefaults.standard.object(forKey: "soundRecognitionEnabled") as? Bool ?? true
    }
}
