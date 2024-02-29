import Foundation
import Speech
import AVFoundation
import SwiftUI

import AVFoundation
import SoundAnalysis
import SwiftUI

class SoundRecognizer: NSObject, ObservableObject {
    private var audioEngine = AVAudioEngine()
    private var soundClassifier: SNClassifySoundRequest?
    private var analysisQueue = DispatchQueue(label: "com.example.SoundAnalysis")

    @Published var detectedSound: String = ""
    @Published var isListening = false

    override init() {
        super.init()
        // Initialize the sound classifier here with a specific model if necessary.
    }

    func startListening() throws {
        let audioFormat = audioEngine.inputNode.inputFormat(forBus: 0)
        // Assuming you have a trained sound classification model, you would initialize the request here.
        // For demonstration purposes, we'll use a generic request initialization.
        guard let model = try? SNClassifier(model: MLModel()) else {
            print("Failed to load sound classification model")
            return
        }
        soundClassifier = SNClassifySoundRequest(mlModel: model)

        try audioEngine.inputNode.removeTap(onBus: 0) // Remove existing taps
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: audioFormat) { [weak self] (buffer, time) in
            // Analyze the audio buffer
            try? self?.analyze(buffer: buffer, at: time)
        }

        audioEngine.prepare()
        try audioEngine.start()
        isListening = true
    }

    private func analyze(buffer: AVAudioPCMBuffer, at time: AVAudioTime) throws {
        guard let soundClassifier = soundClassifier else { return }
        
        // Create a new analysis request for each buffer received
        let request = SNAnalyzeAudioRequest(mlModel: soundClassifier.mlModel)
        let analyzer = try SNAudioStreamAnalyzer(format: buffer.format)
        
        // Add a results observer
        analyzer.add(request, withObserver: self)
        
        // Analyze the current audio buffer
        try analyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
    }

    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        isListening = false
    }
}

// Extend SoundRecognizer to conform to SNResultsObserving for receiving analysis results.
extension SoundRecognizer: SNResultsObserving {
    func request(_ request: SNRequest, didProduce result: SNResult) {
        // Handle the analysis result
        // This example assumes a classification result, which may contain multiple classifications
        guard let classificationResult = result as? SNClassificationResult,
              let classification = classificationResult.classifications.first else { return }
        
        DispatchQueue.main.async {
            self.detectedSound = classification.identifier // The type of sound detected
        }
    }

    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The analysis failed: \(error.localizedDescription)")
    }

    func requestDidComplete(_ request: SNRequest) {
        print("The request completed successfully!")
    }
}

