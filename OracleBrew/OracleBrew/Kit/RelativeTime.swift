//
//  RelativeTime.swift
//  OracleBrew
//
//  Short "how long ago" labels for list timestamps ("now", "5m", "3h", "2d",
//  then a date). The chat list shows these top-right of each row.
//

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
