import Foundation
import FirebaseAuth

@Observable
class SignViewModel{
    
    func signIn(email: String, password: String){
        NotificationInApp.loading = true
        DatabaseService.auth.signIn(withEmail: email, password: password){authResult, error in
            if error == nil{
                //If there is not an error
                NotificationInApp.loading = false
                NotificationInApp.success = true
                NotificationInApp.message = "Logget ind nu!"
            }else{
                //If there is an error
                NotificationInApp.loading = false
                NotificationInApp.error = true
                NotificationInApp.message = "Mail el. adgangskode er forkert"
            }
        }
    }
    
    func signUp(displayName: String, email: String, password: String){
        NotificationInApp.loading = true
        DatabaseService.auth.createUser(withEmail: email, password: password){authResult, error in
            if error == nil{
                //If there is not an error
                NotificationInApp.loading = false
                let profile = ProfileModel(displayName: displayName, email: email.lowercased())
                try? DatabaseService.db.collection("profiles").document().setData(from: profile)
                
                NotificationInApp.success = true
                NotificationInApp.message = "Oprettet ny profil!"
            }else{
                //If there is an error
                NotificationInApp.loading = false
                NotificationInApp.error = true
                NotificationInApp.message = "Mail el. adgangskode er forkert"
            }
        }
    }
    
    func signInCredsAcceptable(email: String, password: String) -> Bool{
        if !email.contains("@") || !email.contains("."){return false}
        if password.count < 6{return false}
        
        return true
    }
    
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
                NotificationInApp.message = "Mail sendt, tjek venligst din mail"
            }else{
                NotificationInApp.loading = false
                NotificationInApp.success = true
                NotificationInApp.message = "Mail sendt, tjek venligst din mail"
            }
        }
    }
}
