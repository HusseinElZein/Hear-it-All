import Foundation
import FirebaseFirestoreSwift


struct CommentModel: Codable, Identifiable {
    @DocumentID var id: String?
    var contentText: String
    var ownerId: String
    
    //Used in the app only
}
