import SwiftUI

struct SignUpView: View {
    var viewModel: SignViewModel
    @State var displayName = ""
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        ZStack{
            Color.backgroundColor.ignoresSafeArea()
            ScrollView{
                VStack{
                    VStack(spacing: 20){
                        VStack(alignment: .leading){
                            Text("Visningsnavn")
                                .font(.callout)
                                .foregroundColor(.gray)
                                .padding(.leading)
                            
                            TextField("", text: $displayName)
                                .keyboardType(.default)
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                ).background(.white)
                                .autocorrectionDisabled()
                                .padding(.horizontal, 20)
                                //.max
                        }
                        .padding(.top, 30)
                        
                        VStack(alignment: .leading){
                            Text("Email")
                                .font(.callout)
                                .foregroundColor(.gray)
                                .padding(.leading)
                            
                            TextField("", text: $email)
                                .keyboardType(.emailAddress)
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                    
                                ).background(.white)
                                .padding(.horizontal, 20)
                        }
                        
                        VStack(alignment: .leading){
                            Text("Adgangskode")
                                .font(.callout)
                                .foregroundColor(.gray)
                                .padding(.leading)
                            
                            SecureField(text: $password) {}
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                                
                            ).background(.white)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 55)
                    
                    Button {
                        viewModel.signUp(displayName: displayName,
                                         email: email,
                                         password: password)
                    } label: {
                        Text("Opret Profil")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 120)
                            .foregroundStyle(.white)
                    }.buttonStyle(.borderedProminent)
                        .tint(.black)
                        .padding(.bottom)
                        .disabled(!viewModel.signUpCredsAcceptable(displayName: displayName, email: email, password: password))
                }.background(Color.backgroundColor)
            }
        }
    }
}

#Preview {
    SignUpView(viewModel: SignViewModel())
}
