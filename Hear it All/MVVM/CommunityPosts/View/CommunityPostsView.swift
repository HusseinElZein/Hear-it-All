import SwiftUI


struct CommunityPostsView: View {
    @StateObject var seePostsViewModel = SeePostsViewModel()
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.backgroundColor.ignoresSafeArea()
                ScrollView{
                    VStack{
                        NavigationLink {
                            CreatePostView()
                        } label: {
                            AddPostButton()
                                .padding(.top, 30)
                        }
                    }
                    VStack{
                        ForEach($seePostsViewModel.posts, id: \.id) { $post in
                            PostView(post: $post) {
                                seePostsViewModel.toggleLike(postId: post.id ?? "")
                            }
                        }
                    }
                    .padding(.bottom, 65)
                }.refreshable {
                    seePostsViewModel.loadAllPosts()
                }
            }
            .navigationTitle("Indlæg")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        ProfileSettingsView()
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .foregroundStyle(.black)
                    }
                }
            }
        }.tint(.black)
    }
}

#Preview {
    CommunityPostsView()
}

struct AddPostButton: View {
    var body: some View {
        HStack {
            Text("Opret post")
                .font(.system(size: 16, weight: .medium, design: .default))
            Spacer()
            Image(systemName: "plus")
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.gray)
        .cornerRadius(5)
        .padding(.horizontal, 25)
    }
}

struct PostView: View {
    @Binding var post: PostModel
    var likeButtonAction: () -> Void
    
    var body: some View {
        VStack{
            VStack(alignment: .leading, spacing: 10){
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
                        Text(post.ownerName ?? "").font(.headline)
                        Text(DateUtil.getTimeAgo(from: post.date))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
                .padding([.horizontal, .top])
                
                // Post title
                Text(post.titleText)
                    .font(.title3)
                    .padding(.horizontal)
            }
            
            // Post image
            if let url = URL(string: post.photo ?? ""){
                AsyncImage(url: url) { image in
                    image.image?
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 200)
                        .cornerRadius(10)
                }
            }
            
            // Like and comment count
            HStack {
                Button(action: {
                    likeButtonAction()
                }) {
                    Image(systemName: "heart")
                        .symbolVariant(post.isLiked ?? false ? .fill : .none)
                        .foregroundStyle(post.isLiked ?? false ? .red : .black)
                }
                Group{
                    if post.likesCount == 1{
                        Text("\(post.likesCount) like")
                    }else{
                        Text("\(post.likesCount) likes")
                    }
                }
                
                Spacer()
                
                Button(action: {
                    // Handle comment action
                }) {
                    Image(systemName: "message")
                        .foregroundStyle(.black)
                }
                Text("120 comments")
            }
            .animation(.easeInOut, value: post.likesCount)
            .padding([.horizontal, .bottom])
            .font(.subheadline)
        }
        .background(Color.postBackgroundColor)
        .cornerRadius(5)
        .shadow(radius: 3)
        .padding()
    }
}

#Preview {
    PostView(post: .constant( PostModel(
        titleText: "How I found my purpose as half deaf",
        contentText: "k",
        ownerId: "Dette er indholdet",
        date: "k",
        photo: "k",
        likesCount: 2,
        comments: [""],
        ownerName: "saraawa")), likeButtonAction: {})
}
