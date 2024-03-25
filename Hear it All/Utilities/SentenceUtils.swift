import Foundation
import SwiftUI

///Counts words of a string in a static function, so no need to instantiate it
class Words {
    static func wordCount(s: String) -> Int {
        let strComponents = s.components(separatedBy: .whitespacesAndNewlines)
        let wordsArray = strComponents.filter { !$0.isEmpty }
        return wordsArray.count
    }
}
