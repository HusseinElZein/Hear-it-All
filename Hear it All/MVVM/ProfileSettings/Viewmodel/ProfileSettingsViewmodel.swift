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
        try? auth.signOut()
    }
    
    func changePassword(to newPasword: String){
        auth.currentUser?.updatePassword(to: newPasword){error in
            if error != nil{
                //if error occured
            }else{
                //if no error
            }
        }
    }
    
    func changeDisplayName(to newName: String){
        db.collection("profile").document(profile?.id ?? "noID").updateData(["displayName": newName]) { error in
            if error != nil{
                
            }else{
                
            }
        }
    }
    
    func changeProfilePicture(imageData: Data) {
        let storageRef = Storage.storage().reference()
        let profilePicRef = storageRef.child("profilePictures/\(profile?.id ?? "noID").jpg")
        
        profilePicRef.putData(imageData, metadata: nil) { metadata, error in
            guard metadata != nil else {
                return
            }
            
            profilePicRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    return
                }
                
                self.profile?.profilePhoto = downloadURL.absoluteString
                
                // Update Firestore with the new profile picture URL
                self.db.collection("profiles").document(self.profile?.id ?? "NoId").updateData(["profilePhoto": downloadURL.absoluteString]) { error in
                    if error != nil {
                    } else {
                        
                    }
                }
            }
        }
    }
    
    func deletePicture() {
        guard let profileId = profile?.id else { return }
        
        let storageRef = Storage.storage().reference()
        let profilePicRef = storageRef.child("profilePictures/\(profileId).jpg")
        
        
        profilePicRef.delete { error in
            if error != nil {
                return
            }
            
            self.db.collection("profiles").document(profileId).updateData(["profilePhoto": FieldValue.delete()]) { error in
                if error != nil {} else {
                    self.profile?.profilePhoto = nil
                }
            }
        }
    }
    
    func deleteProfile(password: String) {
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
                return
            }
            
            self.db.collection("profiles").document(self.profile?.id ?? "noID").delete()
            
            
            
            // Delete the user
            user.delete { error in
                if error != nil {
                    return
                }
            }
        }
    }
}
