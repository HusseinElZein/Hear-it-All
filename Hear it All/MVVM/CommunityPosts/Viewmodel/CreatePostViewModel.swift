import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


@Observable
class CreatePostViewModel{
    private var db = DatabaseService.db
    let auth = DatabaseService.auth
    
    

    func uploadPost(post: PostModel) {
        
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
