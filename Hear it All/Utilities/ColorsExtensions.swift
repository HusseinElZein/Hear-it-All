import Foundation
import SwiftUI


///In order to quicly copy paste hex code into the color, from for example Figma
extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}

///The colors used throughout the application
extension Color {
    public static var backgroundColor: Color {
        return Color(hex: "FBF0E5")
    }
    public static var primaryColor: Color {
        return Color(hex: "F7AD61")
    }
    public static var blueLinkColor: Color {
        return Color(hex: "56A1E6")
    }
    public static var postBackgroundColor: Color {
        return Color(hex: "FFFAF0")
    }
    public static var overlayDarkColor: Color {
        return Color(hex: "353535")
    }
}
