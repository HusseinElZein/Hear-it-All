import SwiftUI


struct ProfileSettingsView: View {
    @State private var displayName: String = "Sara12"
    @State private var email: String = "example@gmail.com"
    @State private var password: String = "password"
    
    @State private var showingEditProfilePicture = false
    @State private var showingEditDisplayName = false
    @State private var showingEditEmail = false
    @State private var showingEditPassword = false
    @State private var showingDeleteAccount = false
    // Add more state variables as needed for other actions

    var body: some View {
        List {
            Section(header:
                        Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 100, height: 100)
                        .overlay(Text("Profile Picture").foregroundColor(.white))
                        .onTapGesture {
                            showingEditProfilePicture.toggle()
                        }
            ) {
                HStack {
                    Image(systemName: "person.fill").foregroundColor(.blue)
                    Text("Display Name")
                    Spacer()
                    Text(displayName)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    showingEditDisplayName.toggle()
                }
                .sheet(isPresented: $showingEditDisplayName) {
                    EditDisplayNameView(displayName: $displayName)
                }

                HStack {
                    Image(systemName: "envelope.fill").foregroundColor(.red)
                    Text("Email")
                    Spacer()
                    Text(email)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    showingEditEmail.toggle()
                }
                .sheet(isPresented: $showingEditEmail) {
                    EditEmailView(email: $email)
                }

                HStack {
                    Image(systemName: "lock.fill").foregroundColor(.gray)
                    Text("Password")
                    Spacer()
                    Text(String(repeating: "•", count: password.count))
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    showingEditPassword.toggle()
                }
                .sheet(isPresented: $showingEditPassword) {
                    EditPasswordView(password: $password)
                }
            }

            Section {
                Button("Sign Out") {
                    // Handle sign out action
                }

                Button("Delete Profile") {
                    showingDeleteAccount.toggle()
                }
                .foregroundColor(.red)
                .sheet(isPresented: $showingDeleteAccount) {
                    // Your delete confirmation view
                    Text("Delete Account Sheet")
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Profile", displayMode: .large)
    }
}

struct EditDisplayNameView: View {
    @Binding var displayName: String
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Display Name", text: $displayName)
            }
            .navigationBarTitle("Edit Display Name", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                // Dismiss the sheet
            })
        }
    }
}

struct EditEmailView: View {
    @Binding var email: String
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Email", text: $email)
            }
            .navigationBarTitle("Edit Email", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                // Dismiss the sheet
            })
        }
    }
}

struct EditPasswordView: View {
    @Binding var password: String
    
    var body: some View {
        NavigationView {
            Form {
                SecureField("Password", text: $password)
            }
            .navigationBarTitle("Edit Password", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                // Dismiss the sheet
            })
        }
    }
}


#Preview {
    ProfileSettingsView()
}
