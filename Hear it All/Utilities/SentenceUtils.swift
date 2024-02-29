import Foundation
import SwiftUI

class Words {
    static func wordCount(s: String) -> Int {
        let strComponents = s.components(separatedBy: .whitespacesAndNewlines)
        let wordsArray = strComponents.filter { !$0.isEmpty }
        return wordsArray.count
    }
}
