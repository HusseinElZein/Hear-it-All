import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift


class SeePostsViewModel : ObservableObject{
    let db = DatabaseService.db
    let auth = DatabaseService.auth
    
    @Published var likedPosts = [String]()
    @Published var posts = [PostModel]()
    
    init(){
        fetchLikedPosts()
        loadAllPosts()
    }
    
    func loadAllPosts() {
        Task { @MainActor in
            NotificationInApp.loading = true
            do {
                let querySnapshot = try await db.collection("posts").getDocuments()
                var posts = querySnapshot.documents.compactMap { document -> PostModel? in
                    try? document.data(as: PostModel.self)
                }
                for i in 0..<posts.count {
                    let (url, name) = await getProfilePictureLinkAndNameForOwner(ownerId: posts[i].ownerId)
                    posts[i].ownerUrlPhoto = url
                    posts[i].ownerName = name
                    
                    if likedPosts.contains(posts[i].id ?? ""){
                        posts[i].isLiked = true
                    }
                }

                // Sort posts by date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                posts.sort { firstPost, secondPost in
                    guard let firstDate = dateFormatter.date(from: firstPost.date),
                          let secondDate = dateFormatter.date(from: secondPost.date) else {
                        return false
                    }
                    return firstDate > secondDate
                }

                self.posts = posts
                
                NotificationInApp.loading = false
            } catch {
                NotificationInApp.loading = false
            }
        }
    }
    
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
                        if let error = error {
                            print("Transaction failed: \(error.localizedDescription)")
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
}
        
    

