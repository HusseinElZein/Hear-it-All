import SwiftUI


/// A view for managing sound and speech recognition settings.
/// This view allows users to enable/disable speech and sound recognition, adjust the number of words before
/// the sentence updates, and navigate to profile and privacy settings.
///
/// - Author: Hussein El-Zein
struct SoundSettingsView: View {
    @Bindable var viewModel: SoundSettingsViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text(Localized.SoundsLocalized.speech_recognition)) {
                    Toggle(isOn: $viewModel.speechRecognitionEnabled) {
                        Text(Localized.SoundsLocalized.speech_recognition)
                    }.tint(.green)
                        .disabled(!viewModel.soundRecognitionEnabled)
                    VStack{
                        HStack{
                            Text("\(Localized.SettingsLocalized.words_before_update) \(String(format: "%.0f", viewModel.numberOfWords))")
                                .font(.footnote)
                            Spacer()
                        }
                        Slider(value: $viewModel.numberOfWords, in: 10...40, step: 1)
                            .tint(Color.primaryColor)
                            .disabled(!viewModel.speechRecognitionEnabled)
                        Button("Reset") {
                            viewModel.resetNumberOfWords()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!viewModel.speechRecognitionEnabled || Int(viewModel.numberOfWords) == 28)
                        .animation(.easeInOut, value: viewModel.numberOfWords)
                    }
                }
                Section(header: Text(Localized.SoundsLocalized.sound_recognition)) {
                    Toggle(isOn: $viewModel.soundRecognitionEnabled) {
                        Text(Localized.SoundsLocalized.sound_recognition)
                    }.tint(.green)
                        .disabled(!viewModel.speechRecognitionEnabled)
                }
                Section(header: Text(Localized.SettingsLocalized.profile_settings)) {
                    NavigationLink {
                        ProfileSettingsView()
                    } label: {
                        Text(Localized.SettingsLocalized.profile_settings)
                    }
                }

                Section {
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Text(Localized.SettingsLocalized.info_privacy)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.backgroundColor)
            .navigationBarTitle(Localized.SettingsLocalized.settings, displayMode: .large)
        }
    }
}


#Preview {
    SoundSettingsView(viewModel: SoundSettingsViewModel())
}
