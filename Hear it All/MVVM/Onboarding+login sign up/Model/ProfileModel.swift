import Foundation
import FirebaseFirestoreSwift

struct ProfileModel: Codable, Identifiable{
    @DocumentID var id : String?
    var displayName: String
    var email: String
    var profilePhoto: String?
}
