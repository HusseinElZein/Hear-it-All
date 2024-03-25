import SplineRuntime
import SwiftUI

///This shows the splineview 3d animation always, but with the view beneath it that changes based on user interaction
struct GenericStartView: View {
    let url = URL(string: "https://build.spline.design/58jK-KLVg5ccje6UgomS/scene.splineswift")!
    
    var body: some View {
        VStack{
            try? SplineView(sceneFileURL: url).ignoresSafeArea(.all)
                .frame(height: 240)
            Spacer()
            SignInOrUpSubView()
        }
        .background(Color.backgroundColor)
    }
}

#Preview {
    GenericStartView()
}
