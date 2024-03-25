import Foundation

///A basic way to save strings in the application, not heavily used but is used
class LocalStorage {
    static func saveString(_ value: String, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func getString(forKey key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
}
