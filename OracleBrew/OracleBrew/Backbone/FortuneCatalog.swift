import Foundation

/// The daily fortune shown on the home screen.
///
/// Bundled rather than fetched: it is one short line, it should be there before
/// the network is, and it has to read naturally in every language — which means
/// living in the string catalog with everything else the user reads.
enum FortuneCatalog {
    static let count = 30

    /// The line for a given day. Stable within a day and the same on every
    /// launch, so the home screen doesn't reshuffle while the user watches.
    static func fortune(for date: Date = .now, calendar: Calendar = .current) -> String {
        let day = calendar.ordinality(of: .day, in: .era, for: date) ?? 0
        return line(at: day % count)
    }

    /// Keys are 1-based to match how the copy is numbered in the content doc.
    ///
    /// The key is built first and handed over as a literal: interpolating
    /// straight into `LocalizationValue` makes the number a format argument, so
    /// the lookup goes to "fortune.%lld", finds nothing, and the raw key ends up
    /// on screen.
    private static func line(at index: Int) -> String {
        let key = "fortune.\(index + 1)"
        return String(localized: String.LocalizationValue(stringLiteral: key))
    }
}
