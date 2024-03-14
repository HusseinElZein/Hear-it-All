import SwiftUI


struct CustomTabBar: View {
    @State private var selection: Int = 0
    @State private var isKeyboardVisible = false
    private let tabDetails = [
        (icon: "house", color: Color.blue.opacity(0.5)),
        (icon: "newspaper", color: Color.green.opacity(0.5))
    ]

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                if selection == 0 {
                    SpeechAndSoundToTextView()
                } else if selection == 1 {
                    CommunityPostsView()
                }
            }.overlay(alignment: .bottom){
                HStack {
                    ForEach(tabDetails.indices, id: \.self) { index in
                        Button(action: {
                            withAnimation {
                                selection = index
                            }
                        }) {
                            TabIconView(iconName: tabDetails[index].icon, isSelected: index == selection)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(selection == index ? tabDetails[index].color.opacity(0.2) : Color.clear)
                                .cornerRadius(10)
                                .shadow(color: tabDetails[index].color, radius: 10, x: 0, y: 5)
                                .offset(y: selection == index ? -5 : 0)
                        }
                        .disabled(index == selection)
                        if index < tabDetails.count - 1 {
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal)
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                    withAnimation {
                        isKeyboardVisible = true
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                    withAnimation {
                        isKeyboardVisible = false
                    }
                }
                .frame(height: 50)
                .background(Color.backgroundColor.gradient)
                .edgesIgnoringSafeArea(.bottom)
                .opacity(isKeyboardVisible ? 0 : 1)
            }
        }
    }
}

struct TabIconView: View {
    var iconName: String
    var isSelected: Bool

    var body: some View {
        Image(systemName: iconName)
            .font(.title2)
            .foregroundColor(isSelected ? .black : .gray)
    }
}

#Preview {
    CustomTabBar()
}
