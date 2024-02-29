import Foundation
import Combine
import AVFoundation
import SoundAnalysis


final class SoundRecognizer: ObservableObject {
    @Published var detectedSound = ""
    @Published var isListening = false
    
    private var audioEngine = AVAudioEngine()
    private var analysisQueue = DispatchQueue(label: "com.example.SoundAnalysis")
    private var streamAnalyzer: SNAudioStreamAnalyzer?
    private var soundAnalysisRequest: SNClassifySoundRequest?
    private var resultsObserver: ResultsObserver?
    
    @Published var userSelectedSounds: Set<String> = [] {
        didSet {
            // Save the updated selections to UserDefaults
            UserDefaults.standard.set(Array(userSelectedSounds), forKey: "UserSelectedSounds")
        }
    }
    
    init() {
        if let savedSounds = UserDefaults.standard.array(forKey: "UserSelectedSounds") as? [String] {
            userSelectedSounds = Set(savedSounds)
        }
        
        let handler = SoundAnalysisHandler()
        handler.onResult = { [weak self] result in
            DispatchQueue.main.async {
                if let classification = result.classifications.first {
                    self?.detectedSound = classification.identifier
                }
            }
        }
        handler.onError = { error in
            print("Analysis error: \(error.localizedDescription)")
        }
        handler.onComplete = {
            print("Analysis completed.")
        }
        
        resultsObserver = ResultsObserver(handler: handler)
    }
    
    func startListening() {
        do {
            isListening = true
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            
            // Set up the audio engine input tap and stream analyzer
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] (buffer, when) in
                self?.analysisQueue.async {
                    self?.streamAnalyzer?.analyze(buffer, atAudioFramePosition: when.sampleTime)
                }
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            // Set up the sound analysis request and add it to the analyzer
            soundAnalysisRequest = try SNClassifySoundRequest(classifierIdentifier: .version1)
            guard let soundAnalysisRequest = soundAnalysisRequest,
                  let resultsObserver = resultsObserver else { return }
            
            streamAnalyzer = SNAudioStreamAnalyzer(format: recordingFormat)
            try streamAnalyzer?.add(soundAnalysisRequest, withObserver: resultsObserver)
        } catch {
            print("Failed to start sound analysis: \(error.localizedDescription)")
            isListening = false
        }
    }
    
    func stopListening() {
        detectedSound = ""
        isListening = false
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        streamAnalyzer = nil
    }
}

final class SoundAnalysisHandler {
    var onResult: ((SNClassificationResult) -> Void)?
    var onError: ((Error) -> Void)?
    var onComplete: (() -> Void)?
}

class ResultsObserver: NSObject, SNResultsObserving {
    let handler: SoundAnalysisHandler
    
    init(handler: SoundAnalysisHandler) {
        self.handler = handler
    }
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        if let result = result as? SNClassificationResult {
            handler.onResult?(result)
        }
    }

    func request(_ request: SNRequest, didFailWithError error: Error) {
        handler.onError?(error)
    }

    func requestDidComplete(_ request: SNRequest) {
        handler.onComplete?()
    }
}

extension SoundRecognizer {
    static func fetchAllKnownSounds() -> [String] {
        do {
            let request = try SNClassifySoundRequest(classifierIdentifier: .version1)
            return request.knownClassifications.sorted()
        } catch {
            print("Failed to fetch known sounds: \(error)")
            return []
        }
    }
}
