import SwiftUI


struct CommunityPostsView: View {
    @Bindable var seePostsViewModel = SeePostsViewModel()
    
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
    var post: PostModel
    var ownerPhotoLink: String
    var ownerName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                AsyncImage(url: URL(string: ownerPhotoLink)) { phase in
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
                            .overlay(Text(ownerName.first.map(String.init) ?? "")
                                .foregroundColor(.white))
                    }
                }
                
                VStack(alignment: .leading) {
                    Text(ownerName).font(.headline)
                    Text("2h ago").font(.subheadline)
                }
                
                Spacer()
            }
            .padding([.horizontal, .top])
            
            // Post title
            Text("How I found my purpose as half deaf")
                .font(.title3)
                .padding(.horizontal)
            
            // Post image
            if post.photo != nil{
                Image("postImage") // Replace with actual image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
            }
            
            // Like and comment count
            HStack {
                Button(action: {
                    // Handle like action
                }) {
                    Image(systemName: "heart")
                        .foregroundStyle(.black)
                }
                Text("200 likes")
                
                Spacer()
                
                Button(action: {
                    // Handle comment action
                }) {
                    Image(systemName: "message")
                        .foregroundStyle(.black)
                }
                Text("120 comments")
            }
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
    PostView(post: PostModel(
        title: "How I found my purpose as half deaf",
        ownerId: "Dette er indholdet",
        theText: "k",
        date: "k",
        photo: "k",
        comments: [""],
        likesCount: 2,
        likedBy: [""]),
             ownerPhotoLink: "", ownerName: "Sara12")
}
