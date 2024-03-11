import SwiftUI

struct CustomTabBar: View {
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            SpeechAndSoundToTextView()
                .tabItem {
                    Image(systemName: selection == 0 ? "house.fill" : "house")
                        .environment(\.symbolVariants, .none)
                }
                .tag(0)
            
            CommunityPostsView()
                .tabItem {
                    Image(systemName: selection == 1 ? "newspaper.fill" : "newspaper")
                        .environment(\.symbolVariants, .none)
                }
                .tag(1)
        }
        .tint(.black)
        .background(Color.backgroundColor)
        .overlay(alignment: .bottom) {
            Rectangle()
                .frame(width: 350, height: 1)
                .padding(.bottom, 55)
        }
    }
}

#Preview {
    CustomTabBar()
}
