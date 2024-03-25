import SwiftUI


/// A view presenting the privacy policy.
/// This view displays detailed information about what data is collected, how it is used, and the user's rights regarding their personal information.
///
/// - Author: Hussein El-Zein
struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Privacy Policy for Hear it All")
                    .font(.title)
                    .padding(.bottom, 5)

                Text("Effective date: 25th of March, 2024")
                    .font(.subheadline)
                    .padding(.bottom, 10)
                
                Group {
                    Text("At Hear it All, accessible from WSAudiology, one of our main priorities is the privacy of our users. This Privacy Policy document contains types of information that is collected and recorded by Hear it All and how we use it.")
                    
                    Text("If you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us.")
                    
                    Section(header: Text("Information We Collect").bold()) {
                        Text("The personal information that you are asked to provide, and the reasons why you are asked to provide it, will be made clear to you at the point we ask you to provide your personal information.")
                        
                        Text("If you contact us directly, we may receive additional information about you such as your name, email address, phone number, the contents of the message and/or attachments you may send us, and any other information you may choose to provide.")
                        
                        Text("When you register for an Account, we may ask for your contact information, including items such as name, company name, address, email address, and telephone number.")
                    }
                }
                
                Group {
                    Section(header: Text("How We Use Your Information").bold()) {
                        Text("We use the information we collect in various ways, including to:")
                        VStack(alignment: .leading) {
                            Text("- Provide, operate, and maintain our app")
                            Text("- Improve and expand our app")
                            Text("- Understand and analyze how you use our app")
                        }
                    }
                    
                    Section(header: Text("Log Files").bold()) {
                        Text("Hear it All follows a standard procedure of using log files. These files log visitors when they use apps. The information collected by log files include, device type, and what kind of crash that crashed the app")
                            .padding(.bottom, 45)
                    }
                }
            }
            .padding()
        }
        .background(Color.backgroundColor)
        .navigationBarTitle("Privacy Policy", displayMode: .inline)
    }
}
