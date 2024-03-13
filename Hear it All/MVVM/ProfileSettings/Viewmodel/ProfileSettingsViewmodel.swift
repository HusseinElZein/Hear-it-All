import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift


@Observable
class ProfileSettingsViewmodel {
    var profile: ProfileModel?
    private var db = DatabaseService.db
    private var auth = DatabaseService.auth
    
    init(){
        fetchProfileData()
    }
    
    private func fetchProfileData() {
        guard let email = auth.currentUser?.email else {
            return
        }
        
        let query = db.collection("profiles").whereField("email", isEqualTo: email)
        
        query.getDocuments { (querySnapshot, error) in
            
            if error != nil{return}
            
            guard let document = querySnapshot?.documents.first else {return}
            
            do {
                let profile = try document.data(as: ProfileModel.self)
                self.profile = profile
            } catch {}
        }
    }
    
    func signOut(){
        NotificationInApp.loading = true
        try? auth.signOut()
        NotificationInApp.loading = false
    }
    
    func changePassword(to newPasword: String){
        auth.currentUser?.updatePassword(to: newPasword){error in
            if error != nil{
                //if error occured
                NotificationInApp.error = true
                NotificationInApp.message = "Prøv igen, eller log ud og ind igen"
            }else{
                //if no error
                NotificationInApp.success = true
                NotificationInApp.message = "Koden er nu ændret!"
            }
        }
    }
    
    func changeDisplayName(to newName: String){
        db.collection("profile").document(profile?.id ?? "noID").updateData(["displayName": newName])
        { error in
            if error != nil{
                NotificationInApp.error = true
                NotificationInApp.message = "Noget gik galt"
            }else{
                NotificationInApp.success = true
                NotificationInApp.message = "Navn er nu skiftet"
            }
        }
    }
    
    func changeProfilePicture(imageData: Data) {
        NotificationInApp.loading = true
        let storageRef = Storage.storage().reference()
        let profilePicRef = storageRef.child("profilePictures/\(profile?.id ?? "noID").jpg")
        
        profilePicRef.putData(imageData, metadata: nil) { metadata, error in
            guard metadata != nil else {
                return
            }
            
            profilePicRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    NotificationInApp.loading = false
                    NotificationInApp.error = true
                    NotificationInApp.message = "Noget gik galt"
                    return
                }
                
                self.profile?.profilePhoto = downloadURL.absoluteString
                
                // Update Firestore with the new profile picture URL
                self.db.collection("profiles").document(self.profile?.id ?? "NoId").updateData(["profilePhoto": downloadURL.absoluteString]) { error in
                    if error != nil {
                        NotificationInApp.error = true
                        NotificationInApp.message = "Noget gik galt"
                    } else {
                        NotificationInApp.success = true
                        NotificationInApp.message = "Profilbillede er nu uploadet!"
                    }
                    NotificationInApp.loading = false
                }
            }
        }
    }
    
    func deletePicture() {
        NotificationInApp.loading = true
        guard let profileId = profile?.id else { return }
        
        let storageRef = Storage.storage().reference()
        let profilePicRef = storageRef.child("profilePictures/\(profileId).jpg")
        
        
        profilePicRef.delete { error in
            if error != nil {
                return
            }
            NotificationInApp.loading = false
            
            self.db.collection("profiles").document(profileId).updateData(["profilePhoto": FieldValue.delete()]) { error in
                if error != nil {
                    NotificationInApp.loading = false
                    NotificationInApp.error = true
                    NotificationInApp.message = "Noget gik galt"
                } else {
                    NotificationInApp.loading = false
                    self.profile?.profilePhoto = nil
                    NotificationInApp.success = true
                    NotificationInApp.message = "Billede er nu slettet"
                }
            }
        }
    }
    
    func deleteProfile(password: String) {
        NotificationInApp.loading = true
        
        guard let user = Auth.auth().currentUser else{return}
        
        guard let profileId = profile?.id else { return }
        
        let storageRef = Storage.storage().reference()
        let profilePicRef = storageRef.child("profilePictures/\(profileId).jpg")
        
        profilePicRef.delete { error in
            if error != nil{
                return
            }
        }

        // Re-authenticate the user
        let credential = EmailAuthProvider.credential(withEmail: profile?.email ?? "error", password: password)
        user.reauthenticate(with: credential) { authResult, error in
            if error != nil {
                NotificationInApp.error = true
                NotificationInApp.message = "Noget gik galt"
                return
            }
            
            self.db.collection("profiles").document(self.profile?.id ?? "noID").delete()
            
            // Delete the user
            user.delete { error in
                if error != nil {
                    NotificationInApp.loading = false
                    NotificationInApp.error = true
                    NotificationInApp.message = "Noget gik galt"
                    return
                }else{
                    NotificationInApp.loading = false
                    NotificationInApp.success = true
                    NotificationInApp.message = "Profil nu slettet"
                }
            }
        }
    }
}
