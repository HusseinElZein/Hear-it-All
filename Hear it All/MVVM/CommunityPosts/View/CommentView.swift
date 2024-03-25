import SwiftUI

/// A view for displaying and managing comments on a specific post.
/// Users can view existing comments and add new ones.
///
/// - Author: Hussein El-Zein
struct CommentView: View {
    var postId: String
    @StateObject var viewModel = CommentViewModel()
    
    var body: some View {
        VStack {
            if viewModel.comments.isEmpty{
                Text("Vær den første til at kommentere!😃")
                    .font(.headline)
                    .padding(.top)
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

/// A view representing a single comment in the comment list, including display name, profile photo, and content.
/// It also provides a delete option if the comment is owned by the current user.
///
/// - Author: Hussein El-Zein
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
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 50, height: 50)
                            .overlay(Text(comment.displayName?.first.map(String.init) ?? "")
                                .foregroundColor(.white))
                    case .empty:
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 50, height: 50)
                            .overlay(Text(comment.displayName?.first.map(String.init) ?? "")
                                .foregroundColor(.white))
                    @unknown default:
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 50, height: 50)
                            .overlay(Text(comment.displayName?.first.map(String.init) ?? "")
                                .foregroundColor(.white))
                    }
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            }else{
                Circle()
                    .fill(Color.gray)
                    .frame(width: 50, height: 50)
                    .overlay(Text(comment.displayName?.first.map(String.init) ?? "")
                        .foregroundColor(.white))
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

/// A view for inputting a new comment with a text field and a post button.
/// It interacts with the comment view model to add new comments to the post.
///
/// - Author: Hussein El-Zein
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
