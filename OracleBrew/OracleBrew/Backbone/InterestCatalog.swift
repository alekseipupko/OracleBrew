import SwiftUI

struct Interest: Identifiable, Hashable {
    let id: String
    let label: String
    let hue: Color
}

enum InterestCatalog {
    static let all: [Interest] = [
        Interest(id: "love", label: "Love", hue: Color(hex: 0xFF7EE1)),
        Interest(id: "family", label: "Family", hue: Color(hex: 0xACD867)),
        Interest(id: "children", label: "Children", hue: Color(hex: 0xFFA77E)),
        Interest(id: "money", label: "Money", hue: Color(hex: 0xFFD47E)),
        Interest(id: "self_growth", label: "Self-Growth", hue: Color(hex: 0xFF7EAB)),
        Interest(id: "career", label: "Career", hue: Color(hex: 0x7E9DFF)),
        Interest(id: "destiny", label: "Destiny", hue: Color(hex: 0xE57EFF)),
        Interest(id: "health", label: "Health", hue: Color(hex: 0x63FBB2)),
        Interest(id: "travel", label: "Travel", hue: Color(hex: 0x7EE7FF)),
        Interest(id: "life_change", label: "Life Change", hue: Color(hex: 0x987EFF)),
        Interest(id: "relationship", label: "Relationship", hue: Color(hex: 0xFD7174)),
        Interest(id: "other", label: "Other", hue: Color(hex: 0xBB7EF7)),
    ]
}
