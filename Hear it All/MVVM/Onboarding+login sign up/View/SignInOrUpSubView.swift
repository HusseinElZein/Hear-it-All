import SwiftUI

///Choosing whether to sign in or sign up
struct SignInOrUpSubView: View {
    @Bindable var viewModel = SignViewModel()
    @State var show = true
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.backgroundColor.ignoresSafeArea()
                VStack{
                    VStack{
                        Text("Hear it All").font(.largeTitle.bold())
                            .padding(.vertical)
                        Text(Localized.ProfileLocalized.choose_how_use_profile)
                            .foregroundStyle(.secondary)
                    }.padding(.top, 30)
                    
                    Spacer()
                    
                    VStack{
                        NavigationLink {
                            SignInView(viewModel: viewModel)
                        } label: {
                            Text(Localized.ProfileLocalized.sign_in)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 120)
                                .foregroundStyle(.white)
                        }.buttonStyle(.borderedProminent)
                            .tint(.black)
                            .padding(.bottom)
                        
                        NavigationLink {
                            SignUpView(viewModel: viewModel)
                        } label: {
                            Text(Localized.ProfileLocalized.sign_up)
                                .padding(.vertical, 14)
                                .padding(.horizontal, 115)
                                .foregroundColor(.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                        }
                    }.padding(.bottom, 30)
                }
            }
        }.tint(.black)
            
    }
}

#Preview {
    SignInOrUpSubView()
}
