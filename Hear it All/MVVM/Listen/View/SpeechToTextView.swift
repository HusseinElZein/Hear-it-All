import SwiftUI

struct SpeechToTextView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var showChooseLanguages = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack{
                    Text("Tale")
                        .fontWeight(.medium)
                        .font(.system(size: 25))
                    Text(speechRecognizer.language.emoji)
                }.onTapGesture {
                    showChooseLanguages.toggle()
                }
                Rectangle()
                    .frame(width: 105, height: 2)
                
                Text(speechRecognizer.transcribedText)
                    .bold()
                    .font(.system(size: 30))
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.2), value: speechRecognizer.transcribedText)
                
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
            .sheet(isPresented: $showChooseLanguages){
                ChooseLanguageView(viewModel: speechRecognizer, showThisSheet: $showChooseLanguages)
            }
    }
}

#Preview(body: {
    SpeechToTextView()
})
