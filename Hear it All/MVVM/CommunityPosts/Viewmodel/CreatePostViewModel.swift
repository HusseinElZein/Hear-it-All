import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


@Observable
class CreatePostViewModel{
    private var db = DatabaseService.db
    private var auth = DatabaseService.auth
    
    var post = PostModel(title: "",
                         ownerId: "",
                         theText: "",
                         date: DateUtil.getDateNow(),
                         comments: [""],
                         likesCount: 0,
                         likedBy: [""])

    func uploadPost() {
        
        let db = Firestore.firestore()
        let collectionRef = db.collection("posts")
        
        do {
            try collectionRef.addDocument(from: post) { error in
                if error != nil {
                    
                } else {
                    
                }
            }
        } catch{
            
        }
    }

    
    func updatePost(){}
}
