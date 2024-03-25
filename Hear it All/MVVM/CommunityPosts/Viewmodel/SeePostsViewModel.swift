import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

/// A view model class for managing the display and interaction with posts.
/// It fetches and paginates posts, manages likes, comments, and deletion of posts.
///
/// - Author: Hussein El-Zein
class SeePostsViewModel : ObservableObject{
    let db = DatabaseService.db
    let auth = DatabaseService.auth
    
    var profile: ProfileModel?
    
    @Published var likedPosts = [String]()
    @Published var posts = [PostModel]()
    
    init(){
        fetchProfileData()
        fetchLikedPosts()
        loadPosts()
    }
    
    /// Refreshes the posts list by resetting the pagination and fetching the first set of posts again.
    func refreshPosts(){
        lastDocumentSnapshot = nil
        self.posts = []
        isLoading = false
        loadPosts()
    }
    
    /// Indicates whether the post loading process is ongoing.
    @Published var isLoading = false
    
    /// The last document snapshot used for paginating the posts.
    private var lastDocumentSnapshot: DocumentSnapshot?
    
    /// Loads the next set of posts, paginated, from Firestore.
    func loadPosts(limit: Int = 6) {
        guard !isLoading else { return }

        isLoading = true

        Task { @MainActor in
            do {
                var query = db.collection("posts").order(by: "date", descending: true).limit(to: limit)
                if let lastSnapshot = lastDocumentSnapshot {
                    query = query.start(afterDocument: lastSnapshot)
                }

                let querySnapshot = try await query.getDocuments()
                var newPosts = querySnapshot.documents.compactMap { document -> PostModel? in
                    try? document.data(as: PostModel.self)
                }
                
                for i in 0..<newPosts.count {
                    let (url, name) = await getProfilePictureLinkAndNameForOwner(ownerId: newPosts[i].ownerId)
                    newPosts[i].ownerUrlPhoto = url
                    newPosts[i].ownerName = name
                    
                    if likedPosts.contains(newPosts[i].id ?? ""){
                        newPosts[i].isLiked = true
                    }
                    if newPosts[i].ownerId == profile?.id {
                        newPosts[i].isOwned = true
                    }
                }

                if !newPosts.isEmpty {
                    lastDocumentSnapshot = querySnapshot.documents.last
                    self.posts.append(contentsOf: newPosts)
                }

                isLoading = false
            } catch {
                isLoading = false
            }
        }
    }

    /// Fetches the list of post IDs that the current user has liked
    private func fetchLikedPosts() {
        guard let userEmail = auth.currentUser?.email else {
            return
        }
        
        let profilesRef = db.collection("profiles")
        let query = profilesRef.whereField("email", isEqualTo: userEmail)
        
        query.getDocuments { (querySnapshot, error) in
            if error != nil {
                return
            }
            
            guard let document = querySnapshot?.documents.first else {
                return
            }
            self.likedPosts = document.get("likedPosts") as? [String] ?? []
        }
    }
    
    func toggleLike(postId: String) {
        guard let userEmail = auth.currentUser?.email else {
            return
        }
        
        let profilesRef = db.collection("profiles")
        let postRef = db.collection("posts").document(postId)
        
        profilesRef.whereField("email", isEqualTo: userEmail).getDocuments { [weak self] querySnapshot, _ in
            guard let self = self, let profileDocument = querySnapshot?.documents.first else {
                return
            }
            
            Task {
                await MainActor.run {
                    self.db.runTransaction { transaction, errorPointer in
                        do {
                            let postDocument = try transaction.getDocument(postRef)
                            var newLikesCount = postDocument.data()?["likesCount"] as? Int ?? 0
                            
                            var tempPosts = self.likedPosts
                            
                            let isPostLiked = self.likedPosts.contains(postId)
                            if isPostLiked {
                                tempPosts.removeAll { $0 == postId }
                                newLikesCount = max(newLikesCount - 1, 0)
                            } else {
                                tempPosts.append(postId)
                                newLikesCount += 1
                            }
                            
                            transaction.updateData(["likedPosts" : tempPosts], forDocument: profilesRef.document(profileDocument.documentID))
                            
                            transaction.updateData(["likesCount": newLikesCount], forDocument: postRef)
                            
                            return true
                        } catch {
                            return false
                        }
                    } completion: { _, error in
                        if error != nil {
                            
                        } else {
                            // Ensures UI updates occur on the main thread.
                            DispatchQueue.main.async {
                                withAnimation {
                                    if let index = self.posts.firstIndex(where: { $0.id == postId }) {
                                        if self.posts[index].isLiked ?? false {
                                            self.likedPosts.removeAll { $0 == postId }
                                            self.posts[index].isLiked = false
                                            self.posts[index].likesCount = self.posts[index].likesCount - 1
                                        } else {
                                            self.likedPosts.append(postId)
                                            self.posts[index].isLiked = true
                                            self.posts[index].likesCount = self.posts[index].likesCount + 1
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func commentOnPost(postId: String, comment: String){}
    
    func getProfilePictureLinkAndNameForOwner(ownerId: String) async -> (url: String?, name: String?) {
        let documentReference = db.collection("profiles").document(ownerId)
        
        do {
            let document = try await documentReference.getDocument()
            let profilePhotoLink = document.data()?["profilePhoto"] as? String
            let displayName = document.data()?["displayName"] as? String
            return (profilePhotoLink, displayName)
        } catch {
            // Handle the error appropriately, maybe log it or return default values
            return (nil, nil)
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
    
    func deletePost(postId: String) {
        db.collection("posts").document(postId).delete { [weak self] error in
            if error != nil {
            } else {
                DispatchQueue.main.async {
                    self?.posts.removeAll { $0.id == postId }
                }
            }
        }
    }
}
        
    

