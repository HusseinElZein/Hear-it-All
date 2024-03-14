import SwiftUI


struct CreatePostView: View {
    @State private var titleText: String = ""
    @State private var contentText: String = ""
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 10) {
                
                HStack {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)
                        .overlay(Text("S").foregroundStyle(.white))
                    
                    VStack(alignment: .leading) {
                        Text("Sara12").bold()
                        Text("2h ago").font(.subheadline)
                    }
                    Spacer()
                }
                .padding([.leading, .trailing])
                
                Divider()
                
                TextEditorApproachView(text: $titleText,
                                       fontType: .title,
                                       placeholder: "Indtast titel",
                                       sizeOfBox: 100)
                .onChange(of: titleText) { _, newValue in
                    titleText = newValue.replacingOccurrences(of: "\n", with: "")
                }
                
                Image("postImage")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding([.leading, .trailing])
                
                TextEditorApproachView(text: $contentText,
                                       placeholder: "Skriv din tekst her")
                    .padding(.bottom, 100)
            }
            
            .toolbar(content: {
                ToolbarItem {
                    Button("Upload") {
                        // Action for Upload
                    }
                }
            })
        }
        .background(Color.backgroundColor)
        .tint(.black)
    }
}

struct TextEditorApproachView: View {
    @Binding var text: String
    var fontType: Font?
    var placeholder: String
    var sizeOfBox: CGFloat?
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .font(fontType)
                    .scrollContentBackground(.hidden)
                    .background(Color.postBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .frame(minHeight: sizeOfBox == nil ? 40 : sizeOfBox, alignment: .leading)
                    .cornerRadius(6.0)
                    .multilineTextAlignment(.leading)
                    .padding(9)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Button("Færdig") {
                                hideKeyboard()
                            }
                        }
                    }
                Text(text.isEmpty ? placeholder : "")
                    .padding()
                    .opacity(text.isEmpty ? 0.7 : 0)
            }
        }
    }
}

#Preview {
    CreatePostView()
    //TextEditorApproachView(text: .constant(""))
}
