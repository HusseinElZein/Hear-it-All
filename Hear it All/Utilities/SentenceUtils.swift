import Foundation
import SwiftUI

class Words {
    static func wordCount(s: String) -> Int {
        let strComponents = s.components(separatedBy: .whitespacesAndNewlines)
        let wordsArray = strComponents.filter { !$0.isEmpty }
        return wordsArray.count
    }
    
    static func keepLast20Words(from string: String) -> String {
        let words = string.split(whereSeparator: { $0.isWhitespace })
        if words.count > 22 {
            return words.suffix(22).joined(separator: " ")
        }
        return string
    }
}
