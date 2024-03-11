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
                }
                Section(header: Text("Antal ord inden sætningen opdateres \n\(String(format: "%.0f", viewModel.numberOfWords))")) {
                    Slider(value: $viewModel.numberOfWords, in: 10...26, step: 1).tint(.blue)
                }
                Section(header: Text("Lydkendelse")) {
                    Toggle(isOn: $viewModel.soundRecognitionEnabled) {
                        Text("Lydkendelse")
                    }.tint(.green)
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
