import Foundation
import FirebaseAuth

@Observable
class SignViewModel{
    
    func signIn(email: String, password: String){
        DatabaseService.auth.signIn(withEmail: email, password: password){authResult, error in
            if error == nil{
                //If there is not an error
            }else{
                //If there is an error
            }
        }
    }
    
    func signUp(displayName: String, email: String, password: String){
        DatabaseService.auth.createUser(withEmail: email, password: password){authResult, error in
            if error == nil{
                //If there is not an error
                let profile = ProfileModel(displayName: displayName, email: email)
                try? DatabaseService.db.collection("profiles").document().setData(from: profile)
            }else{
                //If there is an error
            }
        }
    }
    
    func signOut(){
        try? DatabaseService.auth.signOut()
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
        
    }
}
