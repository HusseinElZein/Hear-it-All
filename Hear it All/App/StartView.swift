import SwiftUI
import FirebaseAuth
import AlertToast

struct StartView: View {
    @Bindable var authListener = UserAuthenticationListener()
    @ObservedObject private var notificationListener = NotificationInAppListener.shared
    
    var body: some View {
        Group{
            if authListener.isUserAuthenticated { //If logged in
                CustomTabBar()
            }else{//If not logged in
                GenericStartView()
                    .backgroundStyle(Color.backgroundColor)
            }
        }
        .toast(isPresenting: $notificationListener.success, duration: 5) {
            AlertToast(displayMode: .hud, type: .complete(.green), title: NotificationInApp.message)
        }
        .toast(isPresenting: $notificationListener.error, duration: 5) {
            AlertToast(displayMode: .hud, type: .error(.red), title: NotificationInApp.message)
        }
        .toast(isPresenting: $notificationListener.loading, duration: 2) {
            AlertToast(displayMode: .alert, type: .loading)
        }
    }
}
