import Foundation
import FirebaseFirestoreSwift

/// A model representing a comment on a post.
/// This struct includes essential information about the comment, as well as additional metadata for app usage.
///
/// - Author: Hussein El-Zein
struct CommentModel: Codable, Identifiable {
    @DocumentID var id: String?
    var contentText: String
    var ownerId: String
    var date: String
    
    //Used in the app only
    var isOwned: Bool?
    var displayName: String?
    var profilePhotoUrl: String?
}
