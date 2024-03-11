import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseService{
    static var db = Firestore.firestore()
    static var auth = Auth.auth()
}
