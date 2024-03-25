import SwiftUI

struct SoundSettingsView: View {
    @Bindable var viewModel: SoundSettingsViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Talegenkendelse")) {
                    Toggle(isOn: $viewModel.speechRecognitionEnabled) {
                        Text("Talegenkendelse")
                    }.tint(.green)
                        .disabled(!viewModel.soundRecognitionEnabled)
                    VStack{
                        HStack{
                            Text("Antal ord inden sætningen opdateres: \(String(format: "%.0f", viewModel.numberOfWords))")
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
                Section(header: Text("Lydkendelse")) {
                    Toggle(isOn: $viewModel.soundRecognitionEnabled) {
                        Text("Lydkendelse")
                    }.tint(.green)
                        .disabled(!viewModel.speechRecognitionEnabled)
                }
                Section(header: Text("Profilindstillinger")) {
                    NavigationLink {
                        ProfileSettingsView()
                    } label: {
                        Text("Profilindstillinger")
                    }
                }

                Section {
                    NavigationLink(destination: Text("Info om privatlivspolitik")) {
                        Text("Info om privatlivspolitik")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.backgroundColor)
            .navigationBarTitle("Indstillinger", displayMode: .large)
        }
    }
}


#Preview {
    SoundSettingsView(viewModel: SoundSettingsViewModel())
}
