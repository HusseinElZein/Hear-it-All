import SwiftUI
import PhotosUI


struct CreatePostView: View {
    @State var viewModel = CreatePostViewModel()
    
    var body: some View {
        ScrollView{
            VStack{
                TextEditorApproachView(text: $viewModel.post.titleText,
                                       fontType: .title,
                                       placeholder: "Indtast titel",
                                       sizeOfBox: 100)
                .onChange(of: viewModel.post.titleText) { _, newValue in
                    viewModel.post.titleText = newValue.replacingOccurrences(of: "\n", with: "")
                }
                
                PickPhotoForPost(vm: viewModel)
                    .padding(.bottom, 50)
                
                TextEditorApproachView(text: $viewModel.post.contentText,
                                       placeholder: "Skriv din tekst her")
                .padding(.bottom, 100)
            }
            .toolbar(content: {
                ToolbarItem {
                    Button("Upload") {
                        viewModel.uploadPost()
                    }.disabled(!viewModel.isPostAcceptable())
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
                Text(text.isEmpty ? placeholder : "")
                    .padding()
                    .opacity(text.isEmpty ? 0.7 : 0)
                    .underline()
                TextEditor(text: $text)
                    .font(fontType)
                    .scrollContentBackground(.hidden)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .frame(minHeight: sizeOfBox == nil ? 50 : sizeOfBox, alignment: .leading)
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
            }
        }
    }
}


struct PickPhotoForPost: View {
    @State private var avatarImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    
    var vm: CreatePostViewModel
    
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



#Preview {
    CreatePostView()
    //TextEditorApproachView(text: .constant(""))
}
