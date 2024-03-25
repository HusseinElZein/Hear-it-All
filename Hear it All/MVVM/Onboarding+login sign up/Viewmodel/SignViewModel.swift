import Foundation
import FirebaseAuth


///Used to sign in, sign up, or forgot password
@Observable
class SignViewModel{
    
    func signIn(email: String, password: String){
        NotificationInApp.loading = true
        DatabaseService.auth.signIn(withEmail: email, password: password){authResult, error in
            if error == nil{
                NotificationInApp.loading = false
                NotificationInApp.success = true
                NotificationInApp.message = Localized.ProfileLocalized.logged_in_message
            }else{
                NotificationInApp.loading = false
                NotificationInApp.error = true
                NotificationInApp.message = Localized.ProfileLocalized.mail_wrong_message
            }
        }
    }
    
    func signUp(displayName: String, email: String, password: String){
        NotificationInApp.loading = true
        DatabaseService.auth.createUser(withEmail: email, password: password){authResult, error in
            if error == nil{
                NotificationInApp.loading = false
                let profile = ProfileModel(displayName: displayName, email: email.lowercased())
                try? DatabaseService.db.collection("profiles").document().setData(from: profile)
                
                NotificationInApp.success = true
                NotificationInApp.message = Localized.ProfileLocalized.created_profile_message
            }else{
                NotificationInApp.loading = false
                NotificationInApp.error = true
                NotificationInApp.message = Localized.ProfileLocalized.mail_wrong_message
            }
        }
    }
    
    ///To disable button or be able to sign in, there are some criteria for the input
    func signInCredsAcceptable(email: String, password: String) -> Bool{
        if !email.contains("@") || !email.contains("."){return false}
        if password.count < 6{return false}
        
        return true
    }
    
    ///To disable button or be able to sign up, there are some criteria for the input
    func signUpCredsAcceptable(displayName: String, email: String, password: String) -> Bool{
        if displayName.isEmpty{return false}
        if !email.contains("@") || !email.contains("."){return false}
        if password.count < 6{return false}
        
        return true
    }
    
    func forgotPassword(email: String){
        NotificationInApp.loading = true
        DatabaseService.auth.sendPasswordReset(withEmail: email){
            error in
            if error != nil{
                NotificationInApp.loading = false
                NotificationInApp.success = true
                NotificationInApp.message = Localized.ProfileLocalized.mail_sent_message
            }else{
                NotificationInApp.loading = false
                NotificationInApp.success = true
                NotificationInApp.message = Localized.ProfileLocalized.mail_sent_message
            }
        }
    }
}
