import Foundation
import FirebaseFirestoreSwift

///This is the model for the person logged in, and for looking at other profiles
struct ProfileModel: Codable, Identifiable{
    @DocumentID var id : String?
    var displayName: String
    var email: String
    var profilePhoto: String?
}
