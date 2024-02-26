//
//  SentenceUtils.swift
//  Hear it All
//
//  Created by Hussein El-Zein on 26/02/2024.
//

import Foundation
import SwiftUI

class Words {
    static func wordCount(s: String) -> Int {
        let strComponents = s.components(separatedBy: .whitespacesAndNewlines)
        let wordsArray = strComponents.filter { !$0.isEmpty }
        return wordsArray.count
    }
    
    static func removeFirst20Words(from string: String) -> String {
        var words = string.split(whereSeparator: { $0.isWhitespace })
        if words.count > 20 {
            words.removeFirst(20)
        }
        return words.joined(separator: " ")
    }
    
    static func removeFirstNWords(from string: String, count n: Int) -> String {
        var words = string.split(whereSeparator: { $0.isWhitespace })
        if words.count > n {
            words.removeFirst(n)
        } else {
            return "" // or return the original string if you don't want to remove all words when count is less than n
        }
        return words.joined(separator: " ")
    }
    
    static func keepLast20Words(from string: String) -> String {
        let words = string.split(whereSeparator: { $0.isWhitespace })
        if words.count > 20 {
            return words.suffix(20).joined(separator: " ")
        }
        return string
    }

}
