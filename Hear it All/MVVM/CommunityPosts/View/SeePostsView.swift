import SwiftUI


struct SeePostsView: View {
    @StateObject var seePostsViewModel = SeePostsViewModel()
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.backgroundColor.ignoresSafeArea()
                ScrollView{
                    VStack{
                        NavigationLink {
                            CreatePostView(posts: $seePostsViewModel.posts, resetPosts: {seePostsViewModel.refreshPosts()})
                        } label: {
                            AddPostButton()
                                .padding(.top, 30)
                        }
                    }
                    LazyVStack{
                        ForEach($seePostsViewModel.posts, id: \.id) { $post in
                            PostView(post: $post, vm: seePostsViewModel) {
                                seePostsViewModel.toggleLike(postId: post.id ?? "")
                            }.onAppear {
                                if $post.id == seePostsViewModel.posts.last?.id {
                                    seePostsViewModel.loadPosts()
                                }
                            }
                        }
                    }
                    .padding(.bottom, 65)
                }.refreshable {
                    seePostsViewModel.refreshPosts()
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
    SeePostsView()
}

struct AddPostButton: View {
    var body: some View {
        VStack{
            HStack {
                Text("Opret post")
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "plus")
                    .foregroundColor(.white)
            }
            .padding(.vertical, 22)
            .padding(.horizontal)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.orange, Color.purple]), startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(15)
            .shadow(color: Color.orange.opacity(0.3), radius: 10, x: 0, y: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.3), Color.clear]), startPoint: .top, endPoint: .bottom), lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }
}


struct PostView: View {
    @Binding var post: PostModel
    var vm: SeePostsViewModel
    var likeButtonAction: () -> Void
    @State var showCommentSheet = false
    
    var body: some View {
        VStack{
            VStack(spacing: 10){
                NavigationLink {
                    OpenPostView(post: $post, likeButtonAction: likeButtonAction)
                } label: {
                    VStack{
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
                                Text(post.ownerName ?? "")
                                    .font(.headline)
                                    .foregroundStyle(.black)
                                Text(DateUtil.getTimeAgo(from: post.date))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding([.horizontal, .top])
                        
                        HStack(){
                            Text(post.titleText)
                                .font(.title3)
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal)
                                .foregroundStyle(.black)
                            Spacer()
                        }
                    }
                }
                NavigationLink {
                    OpenPostView(post: $post, likeButtonAction: likeButtonAction)
                } label: {
                    VStack{
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
                    }
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
                    Group{
                        if post.likesCount == 1{
                            Text("\(post.likesCount) like")
                        }else{
                            Text("\(post.likesCount) likes")
                        }
                    }
                }
                Spacer()
                
                Button(action: {
                    showCommentSheet = true
                }) {
                    Image(systemName: "message")
                        .foregroundStyle(.black)
                    Text("kommentarer")
                }.sheet(isPresented: $showCommentSheet, content: {
                    CommentView(postId: post.id ?? "")
                })
            }
            .animation(.easeInOut, value: post.likesCount)
            .padding([.horizontal, .bottom, .top])
            .font(.subheadline)
            
            if post.isOwned ?? false{
                Menu {
                    //Button("Redigér", action: {})
                    Button("Slet", action: {vm.deletePost(postId: post.id ?? "")})
                } label: {
                    Image(systemName: "ellipsis")
                        .frame(width: 24, height: 24)
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 5)
            }
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
        date: "08/09/2023 22:30",
        photo: "https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGhvdG98ZW58MHx8MHx8fDA%3D",
        likesCount: 2,
        ownerName: "saraawa")), vm: SeePostsViewModel(), likeButtonAction: {}
    )
}
