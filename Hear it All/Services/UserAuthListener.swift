import Foundation
import Combine
import FirebaseAuth


///The listener that the app start uses to determine which screen to show
@Observable
class UserAuthenticationListener{
    var isUserAuthenticated: Bool = false
    private var cancellables: Set<AnyCancellable> = []

    init() {
        // Immediately check the current authentication state
        updateAuthenticationStatus()

        // Subscribe to authentication state changes
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            self?.updateAuthenticationStatus()
        }
    }

    private func updateAuthenticationStatus() {
        if Auth.auth().currentUser != nil {
            isUserAuthenticated = true
        } else {
            isUserAuthenticated = false
        }
    }
}
