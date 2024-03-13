import Foundation

class NotificationInApp {
    static var success: Bool = false {
        didSet {
            NotificationInAppListener.shared.success = success
        }
    }
    static var error: Bool = false {
        didSet {
            NotificationInAppListener.shared.error = error
        }
    }
    
    static var loading: Bool = false {
        didSet {
            NotificationInAppListener.shared.loading = loading
        }
    }
    
    static var message: String = "" {
        didSet {
            NotificationInAppListener.shared.message = message
        }
    }
}

class NotificationInAppListener: ObservableObject {
    static let shared = NotificationInAppListener()

    @Published var success: Bool = false
    @Published var error: Bool = false
    @Published var loading: Bool = false
    @Published var message: String = ""

    private init() {}
}
