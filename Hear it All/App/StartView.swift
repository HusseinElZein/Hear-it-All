import SwiftUI
import FirebaseAuth

struct StartView: View {
    @Bindable var authListener = UserAuthenticationListener()
    
    var body: some View {
        if authListener.isUserAuthenticated { //If logged in
            CustomTabBar()
        }else{//If not logged in
            GenericStartView()
                .backgroundStyle(Color.backgroundColor)
        }
    }
}
