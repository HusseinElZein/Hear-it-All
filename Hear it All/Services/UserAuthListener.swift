import Foundation
import Combine
import FirebaseAuth

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
