import Foundation
import FirebaseFirestoreSwift


/// This model includes properties for storing post information, including metadata and user interaction details.
///
/// - Author: Hussein El-Zein
struct PostModel: Codable, Identifiable {
    @DocumentID var id: String?
    var titleText: String
    var contentText: String
    var ownerId: String
    var date: String
    var photo: String?
    var likesCount: Int = 0
    
    //Used in the app only
    var comments: [CommentModel]?
    var ownerUrlPhoto: String?
    var ownerName: String?
    var isLiked: Bool?
    var isOwned: Bool?
}
