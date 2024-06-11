import XCTest
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
@testable import Hear_it_All

class CreatePostViewModelTests: XCTestCase {
    var viewModel: CreatePostViewModel!
    var mockDB: Firestore!
    var mockStorage: Storage!
    
    override func setUpWithError() throws {
        super.setUp()
        viewModel = CreatePostViewModel()
        mockDB = Firestore.firestore()
        mockStorage = Storage.storage()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockDB = nil
        mockStorage = nil
        super.tearDown()
    }

    func testChoosePhoto() {
        let imageData = Data()
        viewModel.choosePhoto(imageData: imageData)
        
        XCTAssertNotNil(viewModel.imageData, "Image data should be set after choosing photo")
    }

    func testInsertPhoto() {
        let expectation = self.expectation(description: "InsertPhoto")
        
        viewModel.insertPhoto(documentId: "testDocumentId")
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.1)
    }

    func testUploadPost() {
        let expectation = self.expectation(description: "UploadPost")
        
        viewModel.uploadPost()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.1)
    }

    func testIsPostAcceptable() {
        viewModel.post.titleText = "Valid Title"
        viewModel.post.contentText = "This is a valid content text with more than 20 characters."
        
        XCTAssertTrue(viewModel.isPostAcceptable(), "Post should be acceptable with valid title and content")
    }
}
