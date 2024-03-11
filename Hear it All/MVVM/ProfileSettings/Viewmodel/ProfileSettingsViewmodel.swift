import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift


@Observable
class ProfileSettingsViewmodel {
    //var profile: ProfileModel
    
    init(){
        
    }
    
    func loadProfile(){
        //profile.email = DatabaseService.auth.currentUser?.email ?? "NOMAIL"
        //profile.displayName = DatabaseService.db.collection("profiles").whereField(field: "email", isEqualTo: profile.email)
    }
    
    func signOut(){
        try? DatabaseService.auth.signOut()
    }
    
}
