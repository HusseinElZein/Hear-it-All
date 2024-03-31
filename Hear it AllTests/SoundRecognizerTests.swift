import XCTest
@testable import Hear_it_All

class SoundRecognizerTests: XCTestCase {
    var soundRecognizer: SoundRecognizer!

    override func setUpWithError() throws {
        super.setUp()
        soundRecognizer = SoundRecognizer()
    }

    override func tearDownWithError() throws {
        soundRecognizer = nil
        super.tearDown()
    }

    func testUserSelectedSounds() {
        let testSounds = ["sound1", "sound2"]
        soundRecognizer.userSelectedSounds = Set(testSounds)
        XCTAssertEqual(soundRecognizer.userSelectedSounds, Set(testSounds))

        let savedSounds = UserDefaults.standard.array(forKey: "UserSelectedSounds") as? [String]
        XCTAssertEqual(savedSounds?.sorted(), testSounds.sorted())
    }
}
