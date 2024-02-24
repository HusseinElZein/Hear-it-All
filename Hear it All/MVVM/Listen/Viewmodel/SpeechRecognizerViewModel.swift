import Foundation
import Speech
import AVFoundation

class SpeechRecognizer: NSObject, ObservableObject {
    private var audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "da-DE"))
    
    @Published var transcribedText: String = ""
    @Published var isRecording = false

    override init() {
        super.init()
        speechRecognizer?.delegate = self
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
                self?.transcribedText = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self?.stopRecording()
            }
        })
        
        isRecording = true
    }
    
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        isRecording = false
    }
}

extension SpeechRecognizer: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        DispatchQueue.main.async {
            self.isRecording = available
        }
    }
}
