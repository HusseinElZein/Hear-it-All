import SwiftUI
import PhotosUI


struct OpenPostView: View {
    @Binding var post: PostModel
    
    var body: some View {
        ScrollView{
            VStack(spacing: 10) {
                HStack {
                    AsyncImage(url: URL(string: post.ownerUrlPhoto ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        default:
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 40, height: 40)
                                .overlay(Text(post.ownerName?.first.map(String.init) ?? "")
                                    .foregroundColor(.white))
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text(post.ownerName ?? "").bold()
                        Text(DateUtil.getTimeAgo(from: post.date))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    
                }
                .padding([.leading, .trailing])
                
                
                Divider()
                
                VStack(alignment: .leading){
                    HStack{
                        Text(post.titleText)
                            .font(.title)
                            .padding([.leading, .top])
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
                
                if let url = URL(string: post.photo ?? ""){
                    AsyncImage(url: url) { image in
                        image.image?
                            .resizable()
                            .scaledToFill()
                            .frame(width: 300, height: 200)
                            .cornerRadius(10)
                    }
                }
                
                VStack(alignment: .leading){
                    HStack{
                        Text(post.contentText)
                            .padding(.bottom, 250)
                            .padding(.horizontal)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
        }
        .overlay(alignment: .bottom, content: {
            LikeOrCommentOverlay()
                .padding(.bottom, 65)
        })
        .background(Color.backgroundColor)
        .tint(.black)
    }
}


struct LikeOrCommentOverlay: View {
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(Color.overlayDarkColor)
            .frame(width: 145, height: 35)
            .overlay {
                HStack{
                    Spacer()
                    Button {
                    } label: {
                        Image(systemName: "heart")
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    Button(action: {}, label: {
                        Image(systemName: "message")
                            .foregroundStyle(.white)
                    })
                    
                    Spacer()
                }
            }
    }
}


#Preview {
    OpenPostView(
        post: .constant(PostModel(titleText: "This is a test title", contentText: "This is test content text is it a good test? Is it working at the moment?", ownerId: "Some id", date: "08/09/2001 23:30"))
    )
}
