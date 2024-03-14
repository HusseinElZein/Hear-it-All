import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


@Observable
class SeePostsViewModel{
    let db = DatabaseService.db
    let auth = DatabaseService.auth
    
    var posts = [PostModel]()
    
    init(){
        loadAllPosts()
    }
    
    func loadAllPosts() {
        db.collection("posts").getDocuments { (querySnapshot, error) in
            if error != nil {
                
            } else {
                self.posts = querySnapshot?.documents.compactMap { document -> PostModel? in
                    try? document.data(as: PostModel.self)
                } ?? []
            }
        }
    }
    
    func toggleLike(for postId: String) {
        
        let postRef = db.collection("posts").document(postId)
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let postDocument: DocumentSnapshot
            do {
                try postDocument = transaction.getDocument(postRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard let oldLikes = postDocument.data()?["likesCount"] as? Int,
                  let likedBy = postDocument.data()?["likedBy"] as? [String] else {
                let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                    NSLocalizedDescriptionKey: "Unable to retrieve likes count or likedBy array from post."
                ])
                errorPointer?.pointee = error
                return nil
            }
            
            var newLikes = oldLikes
            var updatedLikedBy = likedBy
            
            guard let userId = self.auth.currentUser?.uid else{return}
            
            if likedBy.contains(userId) {
                // User has already liked, so unlike the post
                newLikes -= 1
                updatedLikedBy.removeAll { $0 == userId }
            } else {
                // Like the post
                newLikes += 1
                updatedLikedBy.append(userId)
            }
            
            transaction.updateData(["likesCount": newLikes, "likedBy": updatedLikedBy], forDocument: postRef)
            return nil
        }) { (_, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
            }
        }
    }
    
    func getProfilePictureLinkForOwner(ownerId id: String) -> String {
        
        var link = ""
        
        db.collection("profiles").whereField("ownerId", isEqualTo: id)
            .getDocuments { querySnapshot, error in
                
                if error != nil {
                    return
                }
                
                guard let document = querySnapshot?.documents.first else {
                    return
                }
                
                
                if let profilePhotoLink = document.get("profilePhoto") as? String {
                    link = profilePhotoLink
                }
            }
        return link
    }
}
