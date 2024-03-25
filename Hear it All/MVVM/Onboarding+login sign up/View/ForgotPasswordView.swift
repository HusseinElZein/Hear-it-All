import SwiftUI

///To forget password
struct ForgotPasswordView: View {
    var viewModel: SignViewModel
    @Binding var showMe: Bool
    @State var email = ""
    
    var body: some View {
        ZStack{
            Color.backgroundColor.ignoresSafeArea()
            VStack{
                VStack{
                    VStack(alignment: .leading){
                        Text("Glemt adgangskode?")
                            .font(.title.bold())
                            .padding(.bottom, 25)
                            .padding(.leading)
                        Text("Det kan jo ske! Men bliv ikke bekymret, vi sender dig et link til din email")
                            .foregroundStyle(.gray)
                            .padding([.bottom, .horizontal])
                            .padding(.bottom, 30)
                        
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
                }
                
                Button {
                    viewModel.forgotPassword(email: email)
                    showMe = false
                } label: {
                    Text("Send mail")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 120)
                        .foregroundStyle(.white)
                }.buttonStyle(.borderedProminent)
                    .tint(.black)
                    .padding(.bottom)
                    .disabled(!email.contains("@") || !email.contains("."))
                    .padding(.vertical, 50)
            }
        }
    }
}

#Preview {
    ForgotPasswordView(viewModel: SignViewModel(), showMe: .constant(true))
}
