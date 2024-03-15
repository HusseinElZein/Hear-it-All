import SwiftUI
import PhotosUI


struct OpenPostView: View {
    var post: PostModel
    
    var body: some View {
        ScrollView{
            VStack(spacing: 10) {
                HStack {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)
                        .overlay(Text(post.ownerId)
                            .foregroundStyle(.white))
                    
                    VStack(alignment: .leading) {
                        Text(post.ownerId).bold()
                        Text(DateUtil.getTimeAgo(from: post.date))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding([.leading, .trailing])
                
                Divider()
                
                Text(post.titleText)
                    .font(.title)
                
                //PickPhotoForPost()
                   // .padding(.bottom, 30)
                
                Text(post.contentText)
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



#Preview {
    OpenPostView(
        post: PostModel(titleText: "This is a test title", contentText: "This is test content text is it a good test? Is it working at the moment?",
                        ownerId: "Some id", date: "08/09/2001 23:30")
    )
    //TextEditorApproachView(text: .constant(""))
}
