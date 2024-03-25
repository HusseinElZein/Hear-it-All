import SwiftUI

/// A view for selecting the language for speech recognition.
/// This view displays a list of languages that the user can select from. Selecting a language updates the `SpeechRecognizer` and `SoundRecognizer` view models and closes the view.
///
/// - Author: Hussein El-Zein
struct ChooseLanguageView: View {
    @ObservedObject var viewModel: SpeechRecognizer
    @ObservedObject var soundViewModel: SoundRecognizer
    @Binding var showThisSheet: Bool
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
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
            .scrollContentBackground(.hidden)
            .background(Color.backgroundColor)
            .navigationBarTitle(Localized.LanguageLocalized.choose_language, displayMode: .large)
        }
    }
}

#Preview {
    ChooseLanguageView(viewModel: SpeechRecognizer(), soundViewModel: SoundRecognizer(), showThisSheet: .constant(true))
}
