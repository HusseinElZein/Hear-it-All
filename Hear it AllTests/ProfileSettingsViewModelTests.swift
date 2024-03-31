import XCTest
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseAuth
@testable import Hear_it_All

class ProfileSettingsViewModelTests: XCTestCase {
    var viewModel: ProfileSettingsViewmodel!
    var mockAuth: Auth!
    var mockDb: Firestore!
    var mockStorage: Storage!

    override func setUpWithError() throws {
        super.setUp()
        viewModel = ProfileSettingsViewmodel()
        mockAuth = Auth.auth()
        mockDb = Firestore.firestore()
        mockStorage = Storage.storage()
        
        mockAuth.signIn(withEmail: "husseinelzeinprivat@gmail.com", password: "12345678")
    }

    override func tearDownWithError() throws {
        viewModel = nil
        super.tearDown()
    }
    
    func testChangeDisplayName() {
        // Given
        let newName = "New Name"

        // When
        viewModel.changeDisplayName(to: newName)

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(self.viewModel.profile?.displayName == newName)
        }
    }
    
    func testSignOut() {
        viewModel.signOut()
        
        XCTAssertTrue(Auth.auth().currentUser == nil, "profile should be signed out")
    }
}
