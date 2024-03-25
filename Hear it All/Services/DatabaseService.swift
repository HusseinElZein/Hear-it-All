import Foundation
import FirebaseFirestore
import FirebaseAuth

///In order to not always having an instance in every viewmodel that speaks to the Database, here are its instances
class DatabaseService{
    static var db = Firestore.firestore()
    static var auth = Auth.auth()
}
