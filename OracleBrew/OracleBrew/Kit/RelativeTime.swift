import Foundation

enum RelativeTime {
    static func short(_ date: Date, now: Date = Date()) -> String {
        let seconds = now.timeIntervalSince(date)
        switch seconds {
        case ..<60:
            return String(localized: "time.now")
        case ..<3600:
            return String(localized: "time.minutes \(Int(seconds / 60))")
        case ..<86_400:
            return String(localized: "time.hours \(Int(seconds / 3600))")
        case ..<604_800:
            return String(localized: "time.days \(Int(seconds / 86_400))")
        default:
            return date.formatted(.dateTime.day().month(.abbreviated))
        }
    }
}
