import XCTest
@testable import Hear_it_All

class SpeechRecognizerTests: XCTestCase {
    var speechRecognizer: SpeechRecognizer!

    override func setUpWithError() throws {
        speechRecognizer = SpeechRecognizer()
    }

    override func tearDownWithError() throws {
        speechRecognizer = nil
    }

    func testStartRecordingChangesIsRecordingState() throws {
        let initiallyNotRecording = speechRecognizer.isRecording
        try speechRecognizer.startRecording()
        let startedRecording = speechRecognizer.isRecording

        XCTAssertFalse(initiallyNotRecording)
        XCTAssertTrue(startedRecording)
    }

    func testStopRecordingChangesIsRecordingState() {
        speechRecognizer.stopRecording()
        XCTAssertFalse(speechRecognizer.isRecording)
    }

    func testLanguageChange() {
        let initialLanguage = speechRecognizer.language
        let newLanguage = languageModelData[2]
        speechRecognizer.changeLanguage(to: newLanguage)

        XCTAssertNotEqual(speechRecognizer.language, initialLanguage)
        XCTAssertEqual(speechRecognizer.language, newLanguage)
    }
}
