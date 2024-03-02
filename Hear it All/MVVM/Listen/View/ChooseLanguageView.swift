import SwiftUI

struct ChooseLanguageView: View {
    @ObservedObject var viewModel: SpeechRecognizer
    @ObservedObject var soundViewModel: SoundRecognizer
    @Binding var showThisSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Vælg sprog").font(.title).bold().padding()
            List {
                ForEach(languageModelData, id: \.id) { language in
                    Button(action: {
                        viewModel.changeLanguage(to: language)
                        //Stop all recordings incl. speech and soundrec.
                        soundViewModel.stopListening()
                        
                        showThisSheet.toggle()
                    }) {
                        HStack{
                            Text(language.emoji)
                            Text(language.title)
                        }
                        .foregroundColor(.black)
                    }
                    .disabled(language.id.elementsEqual(viewModel.language.id))
                    .listRowBackground(language.id.elementsEqual(viewModel.language.id) ? Color.gray.opacity(0.3) : .white)
                    
                }
            }
        }
    }
}

#Preview {
    ChooseLanguageView(viewModel: SpeechRecognizer(), soundViewModel: SoundRecognizer(), showThisSheet: .constant(true))
}
