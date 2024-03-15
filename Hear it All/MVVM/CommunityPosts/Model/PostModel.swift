import Foundation
import FirebaseFirestoreSwift


struct PostModel: Codable, Identifiable {
    @DocumentID var id: String?
    var titleText: String
    var contentText: String
    var ownerId: String
    var date: String
    var photo: String?
    var likesCount: Int = 0
    var comments: [String]?
    var likedBy: [String]?
}
