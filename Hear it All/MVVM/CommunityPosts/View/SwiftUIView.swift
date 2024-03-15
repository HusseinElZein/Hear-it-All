import SwiftUI

struct SwiftUIView: View {
    @State var something = 0
    
    var body: some View {
        Text("Hello, World!")
        
        Picker(selection: $something,
               label: Text("Picker")) {
            Text("1").tag(1)
            Text("2").tag(2)
        }
    }
}

#Preview {
    SwiftUIView()
}
