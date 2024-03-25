import SwiftUI


/// A view presenting the privacy policy.
/// This view displays detailed information about what data is collected, how it is used, and the user's rights regarding their personal information.
///
/// - Author: Hussein El-Zein
struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(Localized.PolicyLocalized.politic_title)
                    .font(.title)
                    .padding(.bottom, 5)

                Text(Localized.PolicyLocalized.validity_date)
                    .font(.subheadline)
                    .padding(.bottom, 10)
                
                Group {
                    Text(Localized.PolicyLocalized.colon_1)
                    
                    Text(Localized.PolicyLocalized.colon_2)
                    
                    Section(header: Text(Localized.PolicyLocalized.colon_3).bold()) {
                        Text(Localized.PolicyLocalized.colon_4)
                        
                        Text(Localized.PolicyLocalized.colon_5)
                    }
                }
                
                Group {
                    Section(header: Text(Localized.PolicyLocalized.colon_6).bold()) {
                        Text(Localized.PolicyLocalized.colon_7)
                        VStack(alignment: .leading) {
                            Text(Localized.PolicyLocalized.colon_8)
                            Text(Localized.PolicyLocalized.colon_9)
                            Text(Localized.PolicyLocalized.colon_10)
                        }
                    }
                    
                    Section(header: Text(Localized.PolicyLocalized.colon_11).bold()) {
                        Text(Localized.PolicyLocalized.colon_12)
                            .padding(.bottom, 45)
                    }
                }
            }
            .padding()
        }
        .background(Color.backgroundColor)
        .navigationBarTitle(Localized.SettingsLocalized.profile_settings, displayMode: .inline)
    }
}
