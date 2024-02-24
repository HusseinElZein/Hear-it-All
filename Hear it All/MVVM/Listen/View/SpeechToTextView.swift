import SwiftUI

struct SpeechToTextView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()

    var body: some View {
        VStack {
            Text(speechRecognizer.transcribedText)
                .padding()
            
            Button(speechRecognizer.isRecording ? "Stop Recording" : "Start Recording") {
                if speechRecognizer.isRecording {
                    speechRecognizer.stopRecording()
                } else {
                    try? speechRecognizer.startRecording()
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(speechRecognizer.isRecording ? Color.red : Color.blue)
            .cornerRadius(8)
        }
        .padding()
    }
}
