import SwiftUI
import PhotosUI


struct ProfileSettingsView: View {
    
    @State private var showingEditProfilePicture = false
    @State private var showingEditDisplayName = false
    @State private var showingEditPassword = false
    @State private var showingDeleteAccount = false
    
    @State private var showDeleteConfirmation = false
    
    @Bindable var vm = ProfileSettingsViewmodel()
    @State var password = ""
    
    @State private var avatarImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    
    var body: some View {
            ZStack{
                Color.backgroundColor.ignoresSafeArea()
                VStack{
                    VStack{
                        PhotosPicker(selection: $photosPickerItem, matching: .images) {
                            Group {
                                if let urlString = vm.profile?.profilePhoto, let url = URL(string: urlString) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipShape(Circle())
                                        case .failure(_), .empty:
                                            Circle()
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(width: 100, height: 100)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                } else {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 100, height: 100)
                                        .overlay(Text("Profilbillede").foregroundColor(.white))
                                }
                            }
                        }
                        if ((vm.profile?.profilePhoto?.isEmpty) != nil){
                            Button(action: {
                                showDeleteConfirmation = true
                            }, label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(.black)
                            })
                            .alert(isPresented: $showDeleteConfirmation) {
                                Alert(
                                    title: Text("Slet billede"),
                                    message: Text("Er du sikker på, at du vil slette billedet?"),
                                    primaryButton: .destructive(Text("Ja")) {
                                        vm.deletePicture()
                                    },
                                    secondaryButton: .cancel(Text("Annullér"))
                                )
                            }
                        }
                    }.background(Color.backgroundColor)
                    List {
                        Section {
                            HStack {
                                Image(systemName: "person.fill").foregroundColor(.blue)
                                Text("Visningsnavn")
                                Spacer()
                                Text(vm.profile?.displayName ?? "")
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                showingEditDisplayName.toggle()
                            }
                            .sheet(isPresented: $showingEditDisplayName) {
                                EditDisplayNameView(showMe: $showingEditDisplayName, vm: vm, displayName: vm.profile?.displayName ?? "")
                                    .presentationDetents([.medium])
                            }
                            
                            HStack {
                                Image(systemName: "envelope.fill").foregroundColor(.red)
                                Text("Email")
                                Spacer()
                                Text(vm.profile?.email ?? "")
                            }
                            .contentShape(Rectangle())
                            
                            HStack {
                                Image(systemName: "lock.fill").foregroundColor(.gray)
                                Text("Adgangskode")
                                Spacer()
                                Text(String(repeating: "•", count: 8))
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                showingEditPassword.toggle()
                            }
                            .sheet(isPresented: $showingEditPassword) {
                                EditPasswordView(showMe: $showingEditPassword, vm: vm)
                                    .presentationDetents([.medium])
                            }
                        }
                        
                        Section {
                            Button("Log ud") {
                                vm.signOut()
                            }
                            
                            Button("Slet Profil") {
                                showingDeleteAccount.toggle()
                            }
                            .foregroundColor(.red)
                            .sheet(isPresented: $showingDeleteAccount) {
                                DeleteAccountView(showMe: $showingDeleteAccount, vm: vm)
                                    .presentationDetents([.medium])
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(GroupedListStyle())
                    .navigationBarTitle("Profil", displayMode: .large)
                    .background(Color.backgroundColor)
                }
                .onChange(of: photosPickerItem) { _, _ in
                    // Whenever a new image is chosen
                    Task{
                        if let photosPickerItem,
                           let data = try? await photosPickerItem.loadTransferable(type: Data.self){
                            
                            vm.changeProfilePicture(imageData: data)
                            
                            if let image = UIImage(data: data){
                                avatarImage = image
                            }
                        }
                        photosPickerItem = nil
                    }
                }
            }
    }
}

struct EditDisplayNameView: View {
    @Binding var showMe: Bool
    var vm: ProfileSettingsViewmodel
    var displayName: String
    @State var changedDisplayName = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Visningsnavn", text: $changedDisplayName)
                    .textFieldStyle(.roundedBorder)
            }
            .background(Color.backgroundColor)
            .navigationBarTitle("Skift Visningsnavn", displayMode: .inline)
            .navigationBarItems(trailing: Button("Skift") {
                vm.changeDisplayName(to: changedDisplayName)
                showMe = false
            }.disabled(changedDisplayName.isEmpty || displayName.elementsEqual(changedDisplayName)))
        }
        .onAppear(perform: {changedDisplayName = displayName})
    }
}

struct EditPasswordView: View {
    @Binding var showMe: Bool
    var vm: ProfileSettingsViewmodel
    @State var password = ""
    
    var body: some View {
        NavigationView {
            Form {
                SecureField("Adgangskode", text: $password)
                    .textFieldStyle(.roundedBorder)
            }
            .background(Color.backgroundColor)
            .navigationBarTitle("Skift adgangskode", displayMode: .inline)
            .navigationBarItems(trailing: Button("Skift") {
                vm.changePassword(to: password)
                showMe = false
            }.disabled(password.count < 6))
        }
    }
}

struct DeleteAccountView: View {
    @Binding var showMe: Bool
    var vm: ProfileSettingsViewmodel
    @State var password = ""
    
    var body: some View {
        NavigationView {
            Form {
                SecureField("Adgangskode", text: $password)
                    .textFieldStyle(.roundedBorder)
            }
            .background(Color.backgroundColor)
            .navigationBarTitle("Slet profil", displayMode: .inline)
            .navigationBarItems(trailing: Button("Slet") {
                vm.deleteProfile(password: password)
            }.disabled(password.count < 6))
        }
    }
}

#Preview {
    ProfileSettingsView()
}
