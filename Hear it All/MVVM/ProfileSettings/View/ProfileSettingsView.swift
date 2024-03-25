import SwiftUI
import PhotosUI

/// A view model class for editing and updating an existing post.
/// It manages the post data, handles image selection, and updates the post and associated image in Firestore.
///
/// - Author: Hussein El-Zein
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
                                        .overlay(Text(Localized.ProfileLocalized.profile_picture).foregroundColor(.white))
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
                                    title: Text(Localized.ProfileLocalized.delete_picture),
                                    message: Text(Localized.ProfileLocalized.you_sure),
                                    primaryButton: .destructive(Text(Localized.ProfileLocalized.yes)) {
                                        vm.deletePicture()
                                    },
                                    secondaryButton: .cancel(Text(Localized.ProfileLocalized.cancel))
                                )
                            }
                        }
                    }.background(Color.backgroundColor)
                    List {
                        Section {
                            HStack {
                                Image(systemName: "person.fill").foregroundColor(.blue)
                                Text(Localized.ProfileLocalized.display_name)
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
                                Text(Localized.ProfileLocalized.password)
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
                            Button(Localized.ProfileLocalized.sign_out) {
                                vm.signOut()
                            }
                            
                            Button(Localized.ProfileLocalized.delete_profile) {
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
                    .navigationBarTitle(Localized.ProfileLocalized.profile, displayMode: .large)
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
                TextField(Localized.ProfileLocalized.display_name, text: $changedDisplayName)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.done)
            }
            .background(Color.backgroundColor)
            .navigationBarTitle(Localized.ProfileLocalized.change_display_name, displayMode: .inline)
            .navigationBarItems(trailing: Button(Localized.ProfileLocalized.change) {
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
                SecureField(Localized.ProfileLocalized.password, text: $password)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.done)
            }
            .background(Color.backgroundColor)
            .navigationBarTitle(Localized.ProfileLocalized.change_password, displayMode: .inline)
            .navigationBarItems(trailing: Button(Localized.ProfileLocalized.change) {
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
                SecureField(Localized.ProfileLocalized.password, text: $password)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.done)
            }
            .background(Color.backgroundColor)
            .navigationBarTitle(Localized.ProfileLocalized.delete_profile, displayMode: .inline)
            .navigationBarItems(trailing: Button(Localized.SeePostsLocalized.delete) {
                vm.deleteProfile(password: password)
            }.disabled(password.count < 6))
        }
    }
}

#Preview {
    ProfileSettingsView()
}
