import Foundation


///Same as NotificationInAppListener:
///This is heavily used throughout the application. The notification is a pop up from the top of the screen, either an error
///or success, with its message. These errors/succsesses get set from the viewmodels
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

///Same as NotificationInApp:
///This is heavily used throughout the application. The notification is a pop up from the top of the screen, either an error
///or success, with its message. These errors/succsesses get set from the viewmodels
class NotificationInAppListener: ObservableObject {
    static let shared = NotificationInAppListener()

    @Published var success: Bool = false
    @Published var error: Bool = false
    @Published var loading: Bool = false
    @Published var message: String = ""

    private init() {}
}
