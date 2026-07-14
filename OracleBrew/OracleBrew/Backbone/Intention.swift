//
//  Intention.swift
//  OracleBrew
//
//  What the reading is about: a time horizon, one topic, and an optional
//  free-text question. Topic colors come straight from the Figma palette.
//

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
    let id: String
    let name: String
    let color: Color

    static func == (lhs: Topic, rhs: Topic) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

enum TopicCatalog {
    static let all: [Topic] = [
        Topic(id: "children", name: "Children", color: Color(hex: 0xFFA77E)),
        Topic(id: "family", name: "Family", color: Color(hex: 0xACD867)),
        Topic(id: "love", name: "Love", color: Color(hex: 0xFF7EE1)),
        Topic(id: "money", name: "Money", color: Color(hex: 0xFFD47E)),
        Topic(id: "self_growth", name: "Self-Growth", color: Color(hex: 0xFF7EAB)),
        Topic(id: "career", name: "Career", color: Color(hex: 0x7E9DFF)),
        Topic(id: "destiny", name: "Destiny", color: Color(hex: 0xE57EFF)),
        Topic(id: "travel", name: "Travel", color: Color(hex: 0x7EE7FF)),
        Topic(id: "health", name: "Health", color: Color(hex: 0x63FBB2)),
        Topic(id: "relationship", name: "Relationship", color: Color(hex: 0xFD7174)),
        Topic(id: "life_change", name: "Life Change", color: Color(hex: 0x987EFF)),
        Topic(id: "other", name: "Other", color: Color(hex: 0xBB7EF7))
    ]
}
