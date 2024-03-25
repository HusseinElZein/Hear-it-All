import Foundation

///The date in milliseconds, used on posts and comments. If it is 2 years ago, 2 months ago, etc., and to sort posts
///You get date now to upload now, and getTimeAgo to see how much time ago it was
class DateUtil {
    
    static func getDateNow() -> String {
        let now = Date()
        return String(Int64(now.timeIntervalSince1970 * 1000))
    }
    
    static func getTimeAgo(from millisecondsString: String) -> String {
        guard let milliseconds = Int64(millisecondsString) else {
            return "Invalid date"
        }

        let pastDate = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
        let components = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: pastDate, to: Date())

        if let year = components.year, year > 0 {
            return "\(year) \(Localized.DateLocalized.years_ago)"
        } else if let month = components.month, month > 0 {
            return "\(month) \(Localized.DateLocalized.month)\(month > 1 ? "\(Localized.DateLocalized.months_plural)" : "") \(Localized.DateLocalized.ago)"
        } else if let day = components.day, day > 0 {
            return "\(day)\(Localized.DateLocalized.d_ago)"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)\(Localized.DateLocalized.t_ago)"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)\(Localized.DateLocalized.m_ago)"
        } else {
            return Localized.DateLocalized.just_now
        }
    }
}
