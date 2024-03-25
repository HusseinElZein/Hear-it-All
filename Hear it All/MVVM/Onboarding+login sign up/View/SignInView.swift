import SwiftUI


///To sign in
struct SignInView: View {
    var viewModel: SignViewModel
    @State var email = ""
    @State var password = ""
    @State var showForgotPassword = false
    
    var body: some View {
        ZStack{
            Color.backgroundColor.ignoresSafeArea()
            ScrollView{
                VStack{
                    VStack{
                        VStack(alignment: .leading){
                            Text("Email")
                                .font(.callout)
                                .foregroundColor(.gray)
                                .padding(.leading)
                            TextField("", text: $email)
                                .keyboardType(.emailAddress)
                                .submitLabel(.done)
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                ).background(.white)
                                .padding(.horizontal, 20)
                        }
                        .padding(.vertical)
                        
                        VStack(alignment: .leading){
                            Text("Adgangskode")
                                .font(.callout)
                                .foregroundColor(.gray)
                                .padding(.leading)
                            
                            VStack(alignment: .trailing){
                                SecureField(text: $password) {}
                                    .padding(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray, lineWidth: 1)
                                    ).background(.white)
                                    .submitLabel(.done)
                                    .padding(.horizontal, 20)
                                
                                Button(action: {
                                    showForgotPassword.toggle()
                                }, label: {
                                    Text("Glemt adgangskode?")
                                        .padding(.trailing)
                                        .foregroundStyle(Color.blueLinkColor)
                                        .font(.callout)
                                })
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 55)
                    
                    Button {
                        viewModel.signIn(email: email, password: password)
                    } label: {
                        Text("Log ind")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 120)
                            .foregroundStyle(.white)
                    }.buttonStyle(.borderedProminent)
                        .tint(.black)
                        .padding(.bottom)
                        .disabled(!viewModel.signInCredsAcceptable(email: email, password: password))
                }.background(Color.backgroundColor)
                    .sheet(isPresented: $showForgotPassword, content: {
                        ForgotPasswordView(viewModel: viewModel, showMe: $showForgotPassword)
                    })
            }
        }
    }
}

#Preview {
    SignInView(viewModel: SignViewModel())
}
