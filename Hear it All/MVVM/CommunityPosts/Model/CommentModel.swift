import Foundation
import FirebaseFirestoreSwift


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
