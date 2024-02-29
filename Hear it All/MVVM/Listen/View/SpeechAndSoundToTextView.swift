import SwiftUI

struct SpeechAndSoundToTextView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @StateObject private var soundRecognizer = SoundRecognizer()
    @State private var showChooseLanguages = false
    @State private var showChooseSounds = false
    
    var body: some View {
        VStack {
            //All about speech
            VStack(alignment: .leading) {
                HStack{
                    Text("Tale")
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                    Text(speechRecognizer.language.emoji)
                }.onTapGesture {
                    showChooseLanguages.toggle()
                }
                Rectangle()
                    .frame(width: 105, height: 2)
                
                Rectangle().foregroundStyle(.clear).frame(width: 350, height: 250)
                    .overlay(
                        Text(speechRecognizer.transcribedText)
                            .bold()
                            .font(.system(size: 25))
                            .transition(.opacity)
                            .lineLimit(8)
                            .truncationMode(.head)
                            .animation(.easeInOut(duration: 0.2), value: speechRecognizer.transcribedText),
                        alignment: .topLeading
                    )
                Rectangle().padding()
                    .frame(width: 350, height: 0)
                    .foregroundStyle(.clear)
            }.padding(.top, 50)
            
            //All about recognizing sounds
            VStack(alignment: .leading) {
                HStack{
                    Text("Lydgenkendelse")
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                    Image(systemName: "hifispeaker")
                }.onTapGesture {
                    showChooseSounds.toggle()
                }
                Rectangle()
                    .frame(width: 105, height: 2)
                
                Text(soundRecognizer.detectedSound)
                    .bold()
                    .font(.system(size: 25))
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.2), value: soundRecognizer.detectedSound)
                
                Rectangle().padding()
                    .frame(width: 350, height: 0)
                    .foregroundStyle(.clear)
            }.frame(maxWidth: 350).padding()
            
            Spacer()
            
            //The start and stop button
            Button {
                withAnimation {
                    if soundRecognizer.isListening{
                        soundRecognizer.stopListening()
                    }else {
                        soundRecognizer.startListening()
                    }
                    
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
            .sheet(isPresented: $showChooseSounds) {
                SoundsSelectionView(soundRecognizer: soundRecognizer, availableSounds: SoundRecognizer.fetchAllKnownSounds())
            }
    }
}

#Preview(body: {
    SpeechAndSoundToTextView()
})
