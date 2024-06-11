import XCTest
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseStorage
@testable import Hear_it_All

class SeePostsViewModelTests: XCTestCase {
    var viewModel: SeePostsViewModel!
    var mockDB: Firestore!
    var mockAuth: Auth!

    override func setUpWithError() throws {
        super.setUp()
        viewModel = SeePostsViewModel()
        mockDB = Firestore.firestore()
        mockAuth = Auth.auth()
        
        mockAuth.signIn(withEmail: "husseinelzeinprivat@gmail.com", password: "12345678")
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockDB = nil
        mockAuth = nil
        super.tearDown()
    }

    func testLoadPosts() {
        let expectation = self.expectation(description: "LoadPosts")

        viewModel.loadPosts()

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertFalse(self.viewModel.posts.isEmpty, "Posts should be loaded")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.1)
    }

    func testRefreshPosts() {
        let expectation = self.expectation(description: "RefreshPosts")
        viewModel.refreshPosts()
        XCTAssertTrue(viewModel.isLoading, "isLoading should be true just after refreshing")
        
        XCTAssertTrue(viewModel.posts.isEmpty, "Posts should be empty after refreshing")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(!self.viewModel.posts.isEmpty, "Posts should NOT be empty after refreshing")
            XCTAssertFalse(self.viewModel.isLoading, "isLoading should be false after refreshing is done")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.1)
    }

    func testToggleLike() {
        let postId = "testPostId"
        viewModel.toggleLike(postId: postId)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(self.viewModel.likedPosts.contains(postId), "Posts should be included on the liked list")
        }
    }
}
