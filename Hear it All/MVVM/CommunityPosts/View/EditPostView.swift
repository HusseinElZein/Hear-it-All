import SwiftUI
import PhotosUI


struct EditPostView: View {
    @State var viewModel = EditPostViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var editedPost = PostModel(titleText: "", contentText: "", ownerId: "", date: "")
    
    init(post: PostModel) {
        editedPost = post
    }
    
    var body: some View {
        ScrollView {
            VStack {
                TextEditorApproachView(text: $editedPost.titleText,
                                       fontType: .title,
                                       placeholder: "Indtast titel",
                                       sizeOfBox: 100)
                .onChange(of: editedPost.titleText) { _, newValue in
                    viewModel.post.titleText = newValue.replacingOccurrences(of: "\n", with: "")
                }
                
                PicForPost(vm: viewModel)
                    .padding(.bottom, 50)
                
                TextEditorApproachView(text: $editedPost.contentText,
                                       placeholder: "Skriv din tekst her")
                .padding(.bottom, 100)
            }
            .toolbar {
                ToolbarItem {
                    Button("Opdatér") {
                        viewModel.updatePost()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(!viewModel.isPostAcceptable())
                }
            }
        }
        .background(Color.backgroundColor)
        .tint(.black)
    }
}


struct PicForPost: View {
    @State private var avatarImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    
    var vm: EditPostViewModel
    
    var body: some View {
        PhotosPicker(selection: $photosPickerItem, matching: .images) {
            Group{
                if let image = avatarImage{
                    VStack{
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 300, height: 200)
                            .cornerRadius(10)
                        
                        Button(action: {
                            avatarImage = nil
                            photosPickerItem = nil
                        }, label: {
                            Image(systemName: "trash")
                        })
                    }
                }
                else{
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 150, height: 150)
                        .cornerRadius(10)
                        .overlay(
                            VStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                Text("Vælg foto for dit indlæg")
                                    .foregroundColor(.white)
                                    .padding(.top, 5)
                            })
                }
            }
        }
        .onChange(of: photosPickerItem) { _, _ in
            // Whenever a new image is chosen
            Task{
                if let photosPickerItem,
                   let data = try? await photosPickerItem.loadTransferable(type: Data.self){
                    
                    vm.choosePhoto(imageData: data)
                    
                    if let image = UIImage(data: data){
                        avatarImage = image
                    }
                }
                photosPickerItem = nil
            }
        }
    }
}
