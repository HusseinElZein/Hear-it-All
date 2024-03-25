import SwiftUI

struct CommentView: View {
    var postId: String
    @StateObject var viewModel = CommentViewModel()
    
    var body: some View {
        VStack {
            if viewModel.comments.isEmpty{
                Text("Vær den første til at kommentere!")
                    .font(.headline)
            }
            List($viewModel.comments, id: \.id) { $comment in
                OneComment(comment: $comment, onDelete: {viewModel.deleteComment(postId: postId, commentId: comment.id ?? "")})
            }
            .scrollContentBackground(.hidden)
            .background(Color.backgroundColor)
            .onAppear {
                viewModel.loadAllComments(for: postId)
            }
            .padding(.top)
            
            CommentInputView(postId: postId, viewModel: viewModel)
        }.background(Color.backgroundColor)
    }
}

private struct OneComment: View {
    @Binding var comment: CommentModel
    
    var onDelete: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let imageUrl = comment.profilePhotoUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    case .failure(_):
                        Image(systemName: "person.fill").resizable()
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            }
            
            // Comment details
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(comment.displayName ?? "")
                        .font(.system(size: 14, weight: .semibold))
                    Spacer()
                    Text(DateUtil.getTimeAgo(from: comment.date))
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                
                // Comment Text
                Text(comment.contentText)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Delete Button
                if comment.isOwned == true {
                    Button("slet", action: {
                        onDelete()
                    })
                    .font(.system(size: 12))
                    .foregroundColor(.red)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.8))
        .cornerRadius(8) // Add a corner radius if desired
    }
}


private struct CommentInputView: View {
    var postId: String
    @StateObject var viewModel: CommentViewModel
    @State private var newCommentText = ""
    
    var body: some View {
        HStack {
            TextField("Tilføj en kommentar...", text: $newCommentText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Post") {
                viewModel.commentOnPost(postId: postId, comment: newCommentText)
                newCommentText = ""
                hideKeyboard()
            }
            .foregroundStyle(.black)
            .disabled(newCommentText.count < 1)
        }
        .padding()
        .background(Color.backgroundColor)
    }
}
