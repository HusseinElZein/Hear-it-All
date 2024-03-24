import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class CommentViewModel: ObservableObject {
    let db = DatabaseService.db
    let auth = DatabaseService.auth
    
    @Published var comments = [CommentModel]()
    
    var profile: ProfileModel?
    
    init(){
        fetchProfileData()
    }

    func loadAllComments(for postId: String) {
        Task { @MainActor in
            // Assume newComments is populated here in some async manner
            let newComments: [CommentModel] = await fetchComments(for: postId)
            
            // Now update the published property on the main thread
            self.comments = newComments
        }
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

    // Assuming fetchComments is an async function
    func fetchComments(for postId: String) async -> [CommentModel] {
        // Fetch comments asynchronously
        do {
            let querySnapshot = try await db.collection("posts").document(postId).collection("comments").getDocuments()
            var comments = querySnapshot.documents.compactMap { document -> CommentModel? in
                try? document.data(as: CommentModel.self)
            }
            // Process each comment
            for i in 0..<comments.count {
                let (url, name) = await getProfilePictureLinkAndNameForOwner(ownerId: comments[i].ownerId)
                comments[i].profilePhotoUrl = url
                comments[i].displayName = name
                comments[i].isOwned = comments[i].ownerId == profile?.id ?? ""
            }
            return comments
        } catch {
            print("Error fetching comments: \(error)")
            return []
        }
    }

    func commentOnPost(postId: String, comment: String) {
        guard let ownerId = profile?.id else { return }
        let commentModel = CommentModel(contentText: comment, ownerId: ownerId, date: DateUtil.getDateNow())
        
        do {
            try db.collection("posts").document(postId).collection("comments").addDocument(from: commentModel)
            
            DispatchQueue.main.async {
                self.comments.append(commentModel)
            }
            
        } catch {
            print("Error commenting on post: \(error)")
        }
        loadAllComments(for: postId)
    }
    
    func getProfilePictureLinkAndNameForOwner(ownerId: String) async -> (url: String?, name: String?) {
        let documentReference = db.collection("profiles").document(ownerId)
        do {
            let document = try await documentReference.getDocument()
            let profilePhotoLink = document.data()?["profilePhoto"] as? String
            let displayName = document.data()?["displayName"] as? String
            return (profilePhotoLink, displayName)
        } catch {
            print("Error fetching profile info: \(error)")
            return (nil, nil)
        }
    }
    
    func deleteComment(postId: String, commentId: String) {
        db.collection("posts").document(postId).collection("comments").document(commentId).delete { [weak self] error in
            if error != nil {
                return
            }
            
            DispatchQueue.main.async {
                self?.comments.removeAll { $0.id == commentId }
            }
        }
    }

}
