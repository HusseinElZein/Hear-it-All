import XCTest
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseAuth
@testable import Hear_it_All


class SignViewModelTests: XCTestCase {
    var viewModel: SignViewModel!
    var testUserEmail: String!
    var testUserPassword: String = "TestPassword123!"

    override func setUpWithError() throws {
        super.setUp()
        viewModel = SignViewModel()
        testUserEmail = "test\(Int.random(in: 100000...999999))@example.com"
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    func testSignUp() {
        let signUpExpectation = expectation(description: "signUp")

        viewModel.signUp(displayName: "Test User", email: testUserEmail, password: testUserPassword)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if NotificationInApp.success {
                XCTAssertTrue(NotificationInApp.success, "Sign up should succeed.")
                signUpExpectation.fulfill()
            } else {
                XCTFail("Sign up failed with message: \(NotificationInApp.message)")
            }
        }

        waitForExpectations(timeout: 10)
    }

    func testSignIn() {
        let signInExpectation = expectation(description: "signIn")
        
        viewModel.signIn(email: "husseinelzeinprivat@gmail.com", password: "12345678")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if NotificationInApp.success {
                XCTAssertTrue(NotificationInApp.success, "Sign in should succeed.")
                signInExpectation.fulfill()
            } else {
                XCTFail("Sign in failed with message: \(NotificationInApp.message)")
            }
        }

        waitForExpectations(timeout: 10)
    }

    func deleteUser() {
        let deleteExpectation = expectation(description: "deleteUser")
        
        Auth.auth().signIn(withEmail: testUserEmail, password: testUserPassword) { authResult, error in
            XCTAssertNil(error)
            XCTAssertNotNil(authResult)

            Auth.auth().currentUser?.delete { error in
                XCTAssertNil(error, "User deletion should succeed.")
                deleteExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10)
    }
}

