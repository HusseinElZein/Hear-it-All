import XCTest
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseAuth
@testable import Hear_it_All

class SoundSettingsViewModelTests: XCTestCase {
    var viewModel: SoundSettingsViewModel!
    var userDefaults: UserDefaults!

    override func setUpWithError() throws {
        super.setUp()
        viewModel = SoundSettingsViewModel()
        viewModel.resetNumberOfWords()
        viewModel.speechRecognitionEnabled = true
        viewModel.soundRecognitionEnabled = true
    }

    override func tearDownWithError() throws {
        viewModel = nil
        super.tearDown()
    }

    func testInitialization() {
        XCTAssertTrue(viewModel.speechRecognitionEnabled, "Speech recognition should be enabled by default")
        XCTAssertEqual(viewModel.numberOfWords, 28.0, "Default number of words should be 28")
        XCTAssertTrue(viewModel.soundRecognitionEnabled, "Sound recognition should be enabled by default")
    }

    func testPropertySetters() {
        // Test speechRecognitionEnabled setter
        viewModel.speechRecognitionEnabled = false
        XCTAssertFalse(viewModel.speechRecognitionEnabled, "speechRecognitionEnabled should be false now")

        // Test numberOfWords setter
        viewModel.numberOfWords = 30.0
        XCTAssertEqual(viewModel.numberOfWords, 30.0, "numberOfWords should be 30")

        // Test soundRecognitionEnabled setter
        viewModel.soundRecognitionEnabled = false
        XCTAssertFalse(viewModel.soundRecognitionEnabled, "soundRecognitionEnabled should be false now")
    }

    func testResetNumberOfWords() {
        // Change the value then reset
        viewModel.numberOfWords = 30.0
        viewModel.resetNumberOfWords()

        // Check the value is reset
        XCTAssertEqual(viewModel.numberOfWords, 28.0, "resetNumberOfWords should reset numberOfWords to 28")
    }
}
