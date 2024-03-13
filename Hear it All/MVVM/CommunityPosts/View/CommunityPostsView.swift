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
        }
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
