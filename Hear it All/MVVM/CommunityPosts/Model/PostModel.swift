import Foundation
import FirebaseFirestoreSwift


struct PostModel: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var ownerId: String
    var theText: String
    var date: String
    var photo: String?
    var comments: [String]
    var likesCount: Int
    var likedBy: [String]
}
