import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage


/// A view model class for creating and uploading new posts.
/// It manages the data entry for a new post, handles image selection, uploads the post and associated image,
/// and verifies the post's content before submission.
///
/// - Author: Hussein El-Zein
@Observable
class CreatePostViewModel{
    private var db = DatabaseService.db
    private var auth = DatabaseService.auth
    
    var imageData: Data?
    
    init(){
        fetchProfileData()
    }
    var profile: ProfileModel?
    func fetchProfileData() {
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
    
    var post = PostModel(titleText: "",
                         contentText: "",
                         ownerId: "",
                         date: "")
    
    
    func choosePhoto(imageData: Data){
        self.imageData = imageData
    }
    
    /// Uploads the selected photo to Firebase Storage and updates the Firestore post document with the photo URL.
    func insertPhoto(documentId: String){
        guard let imgData = imageData else {
            return
        }
        
        NotificationInApp.loading = true
        let storageRef = Storage.storage().reference()
        let picRef = storageRef.child("postPictures/\(documentId).jpg")
        
        picRef.putData(imgData, metadata: nil) { metadata, error in
            guard metadata != nil else {
                return
            }
            
            picRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    NotificationInApp.loading = false
                    NotificationInApp.error = true
                    NotificationInApp.message = Localized.CreatePostLocalized.something_wrong
                    return
                }
                
                // Update Firestore with the new profile picture URL
                self.db.collection("posts").document(documentId).updateData(["photo": downloadURL.absoluteString]) { error in
                    if error != nil {
                        NotificationInApp.error = true
                        NotificationInApp.message = Localized.CreatePostLocalized.something_wrong
                    } else {
                        NotificationInApp.success = true
                        NotificationInApp.message = Localized.CreatePostLocalized.now_posted
                    }
                    NotificationInApp.loading = false
                }
            }
        }
    }
    
    func uploadPost() {
        post.ownerId = profile?.id ?? "noId"
        post.date = DateUtil.getDateNow()
        
        let collectionRef = db.collection("posts")
        
        let docRef = collectionRef.document()
        
        do {
            try docRef.setData(from: post) {error in
                if error != nil {
                } else {}
            }
            insertPhoto(documentId: docRef.documentID)
        } catch{}
    }
    
    /// Checks if the post meets the minimum criteria for content and title length.
    func isPostAcceptable() -> Bool{
        if post.contentText.count < 20{return false}
        if post.titleText.count < 3{return false}
        
        return true
    }
}
