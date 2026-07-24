import SwiftUI

enum TimeHorizon: String, CaseIterable, Identifiable {
    case days, month, year
    var id: String { rawValue }

    var titleKey: LocalizedStringKey {
        switch self {
        case .days: "intention.horizon.days"
        case .month: "intention.horizon.month"
        case .year: "intention.horizon.year"
        }
    }
}

struct Topic: Identifiable, Hashable {
    let id: String          // slug — stable identity, drives the chip colour
    let name: String
    let color: Color
    /// The backend's numeric topic id, needed when creating a reading. nil for
    /// the bundled mock topics.
    var numericID: Int? = nil

    static func == (lhs: Topic, rhs: Topic) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

enum TopicCatalog {
    /// The display name for a topic slug, from the app's own strings.
    ///
    /// The backend sends `title` in English only, and these are the same twelve
    /// slugs the profile's interests use — so they reuse those translations
    /// rather than carrying a second, English-only copy.
    static func localizedName(forSlug slug: String) -> String? {
        guard all.contains(where: { $0.id == slug }) else { return nil }
        return String(localized: String.LocalizationValue(stringLiteral: "interest.\(slug)"))
    }

    static let all: [Topic] = [
        Topic(id: "children", name: String(localized: "interest.children"), color: Color(hex: 0xFFA77E)),
        Topic(id: "family", name: String(localized: "interest.family"), color: Color(hex: 0xACD867)),
        Topic(id: "love", name: String(localized: "interest.love"), color: Color(hex: 0xFF7EE1)),
        Topic(id: "money", name: String(localized: "interest.money"), color: Color(hex: 0xFFD47E)),
        Topic(id: "self_growth", name: String(localized: "interest.self_growth"), color: Color(hex: 0xFF7EAB)),
        Topic(id: "career", name: String(localized: "interest.career"), color: Color(hex: 0x7E9DFF)),
        Topic(id: "destiny", name: String(localized: "interest.destiny"), color: Color(hex: 0xE57EFF)),
        Topic(id: "travel", name: String(localized: "interest.travel"), color: Color(hex: 0x7EE7FF)),
        Topic(id: "health", name: String(localized: "interest.health"), color: Color(hex: 0x63FBB2)),
        Topic(id: "relationship", name: String(localized: "interest.relationship"), color: Color(hex: 0xFD7174)),
        Topic(id: "life_change", name: String(localized: "interest.life_change"), color: Color(hex: 0x987EFF)),
        Topic(id: "other", name: String(localized: "interest.other"), color: Color(hex: 0xBB7EF7))
    ]
}
