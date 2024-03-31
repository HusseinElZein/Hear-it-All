import XCTest
import Foundation
import FirebaseFirestoreSwift
import FirebaseAuth
@testable import Hear_it_All

final class HearItAllUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testStartViewAppearance() {
        let signInButton = app.buttons[Localized.ProfileLocalized.sign_in]
        let signUpButton = app.buttons[Localized.ProfileLocalized.sign_up]

        XCTAssertTrue(signInButton.exists, "Sign In button should be visible on start view")
        XCTAssertTrue(signUpButton.exists, "Sign Up button should be visible on start view")
    }

    func testNavigationToSignInView() {
        app.buttons[Localized.ProfileLocalized.sign_in].tap()
        let emailTextField = app.textFields["Email"]
        let passwordSecureField = app.secureTextFields[Localized.ProfileLocalized.password]

        XCTAssertTrue(emailTextField.exists, "Email text field should be present on Sign In view")
        XCTAssertTrue(passwordSecureField.exists, "Password field should be present on Sign In view")
    }

    func testNavigationToSignUpView() {
        app.buttons[Localized.ProfileLocalized.sign_up].tap()
        let displayNameTextField = app.textFields[Localized.ProfileLocalized.display_name]
        let emailTextField = app.textFields["Email"]
        let passwordSecureField = app.secureTextFields[Localized.ProfileLocalized.password]

        XCTAssertTrue(displayNameTextField.exists, "Display Name text field should be present on Sign Up view")
        XCTAssertTrue(emailTextField.exists, "Email text field should be present on Sign Up view")
        XCTAssertTrue(passwordSecureField.exists, "Password field should be present on Sign Up view")
    }
}
