import Foundation

class DateUtil {
    
    static func getDateNow() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: Date())
    }
    
    static func getTimeAgo(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        guard let pastDate = formatter.date(from: dateString) else {
            return "Invalid date"
        }
        
        let components = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: pastDate, to: Date())

        if let year = components.year, year > 0 {
            return "\(year) år siden"
        } else if let month = components.month, month > 0 {
            return "\(month) måned\(month > 1 ? "er" : "") siden"
        } else if let day = components.day, day > 0 {
            return "\(day)d siden"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)t siden"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)m siden"
        } else {
            return "Lige nu"
        }
    }
}
