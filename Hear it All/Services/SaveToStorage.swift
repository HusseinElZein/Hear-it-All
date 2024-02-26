import Foundation

class LocalStorage {
    static func save(_ value: String, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func getString(forKey key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
}
