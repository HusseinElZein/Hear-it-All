import SwiftUI

struct SpeechToTextView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Tale")
                    .fontWeight(.medium)
                    .font(.system(size: 25))
                Rectangle()
                    .frame(width: 105, height: 2)
                
                Text(speechRecognizer.transcribedTextNewestTwenty)
                    .bold()
                    .font(.system(size: 30))
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.2), value: speechRecognizer.transcribedTextNewestTwenty)
                
                Rectangle().padding()
                    .frame(width: 350, height: 0)
                    .foregroundStyle(.clear)
            }.frame(maxWidth: 350)
            .padding()
            
            Spacer()
            
            //The start and stop button
            Button {
                withAnimation {
                    if speechRecognizer.isRecording {
                        speechRecognizer.stopRecording()
                    } else {
                        try? speechRecognizer.startRecording()
                    }
                }
            } label: {
                Image(systemName: speechRecognizer.isRecording ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 75))
                    .foregroundStyle(Color.primaryColor)
            }
            .contentTransition(.symbolEffect(.replace))
        }.backgroundStyle(Color.backgroundColor)
    }
}

#Preview(body: {
    SpeechToTextView()
})
