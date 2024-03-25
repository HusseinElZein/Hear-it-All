import Foundation
import Speech
import AVFoundation
import SwiftUI

class SpeechRecognizer: NSObject, ObservableObject {
    private var audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    @Published var language = languageModelData[0]
    private var speechRecognizer: SFSpeechRecognizer?
    @Published var transcribedText: String = ""
    @Published var isRecording = false
    @Published private var wordsToCount = 28
    
    override init() {
        super.init()
        let locale_id = LocalStorage.getString(forKey: "locale_id") ?? "da-DE"
        self.language = LanguageHelper.getLanguageModel(byLocaleId: locale_id) ?? languageModelData[0]
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: self.language.locale_id))
    }
    
    func startRecording() throws {
        // Check if recognizer is available
        if !(speechRecognizer?.isAvailable ?? false) {
            throw NSError(domain: "SFSpeechRecognizerErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Speech recognition is not currently available."])
        }
        
        // Configure the audio session
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        // Prepare the recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a recognition request") }
        recognitionRequest.shouldReportPartialResults = true
        
        // Configure the microphone input
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        // Start speech recognition
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { [weak self] (result, error) in
            var isFinal = false
            
            if let result = result {
                let fullTranscription = result.bestTranscription.formattedString
                let words = fullTranscription.split(whereSeparator: { $0.isWhitespace }).map(String.init)
                
                let counterForWords = self?.wordsToCount ?? 28
                
                // Calculate the start index for slicing the words array to get the last set of up to 10 words
                let sliceStartIndex = max(0, words.count - (words.count % counterForWords) - (words.count % counterForWords == 0 ? counterForWords : 0))
                let relevantWords = words.suffix(from: sliceStartIndex)
                withAnimation {
                    self?.transcribedText = relevantWords.joined(separator: " ")
                }
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self?.stopRecording()
            }
        })
        isRecording = true
    }
    
    func stopRecording() {
        transcribedText = ""
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        isRecording = false
    }
    
    func changeLanguage(to newLanguage: LanguageModel){
        if isRecording {stopRecording()}
        LocalStorage.saveString(newLanguage.locale_id, forKey: "locale_id")
        self.language = newLanguage
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: newLanguage.locale_id))
        self.transcribedText = ""
    }
    
    func handleToggle(isEnabled: Bool, wordsToCount: Int){
        self.wordsToCount = wordsToCount
        if !isEnabled {return}
        if isRecording {stopRecording()}
        else{try? startRecording()}
    }
}
