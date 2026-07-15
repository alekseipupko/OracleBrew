//
//  UserProfile.swift
//  OracleBrew
//
//  The user's own details, gathered on the Profile screen. Feeds the greeting
//  ("Hi Susan!") and, later, the reading's personalization. Persisted locally
//  via UserDefaults — v1.0 has no backend.
//

import Foundation

// MARK: Field options

enum Identity: String, CaseIterable, Codable, Identifiable {
    case female, male, ratherNot
    var id: String { rawValue }

    var label: String {
        switch self {
        case .female: "Female"
        case .male: "Male"
        case .ratherNot: "Rather Not"
        }
    }
}

enum RelationshipStatus: String, CaseIterable, Codable, Identifiable {
    case married, inRelationship, single, divorced, complicated
    var id: String { rawValue }

    var label: String {
        switch self {
        case .married: "Married"
        case .inRelationship: "In a relationship"
        case .single: "Single"
        case .divorced: "Divorced"
        case .complicated: "It's complicated"
        }
    }
}

enum Employment: String, CaseIterable, Codable, Identifiable {
    case studying, working, retired, both, seeking
    var id: String { rawValue }

    var label: String {
        switch self {
        case .studying: "Studying"
        case .working: "Working"
        case .retired: "Retired"
        case .both: "Both"
        case .seeking: "Seeking"
        }
    }
}

enum ChildrenStatus: String, CaseIterable, Codable, Identifiable {
    case have, none, planning
    var id: String { rawValue }

    var label: String {
        switch self {
        case .have: "Have children"
        case .none: "No children"
        case .planning: "Planning"
        }
    }
}

// MARK: Zodiac

enum Zodiac: String, Codable, CaseIterable {
    case aries, taurus, gemini, cancer, leo, virgo
    case libra, scorpio, sagittarius, capricorn, aquarius, pisces

    var name: String { rawValue.capitalized }

    /// U+FE0E forces text presentation — without it iOS renders these as
    /// colour emoji, which ignores the label's tint.
    var glyph: String {
        let symbol: String = switch self {
        case .aries: "♈"
        case .taurus: "♉"
        case .gemini: "♊"
        case .cancer: "♋"
        case .leo: "♌"
        case .virgo: "♍"
        case .libra: "♎"
        case .scorpio: "♏"
        case .sagittarius: "♐"
        case .capricorn: "♑"
        case .aquarius: "♒"
        case .pisces: "♓"
        }
        return symbol + "\u{FE0E}"
    }

    /// Western tropical zodiac. Each entry is the sign's *start* day within its
    /// month; a date before its month's cutoff belongs to the previous sign.
    private static let cutoffs: [(month: Int, day: Int, sign: Zodiac)] = [
        (1, 20, .aquarius), (2, 19, .pisces), (3, 21, .aries), (4, 20, .taurus),
        (5, 21, .gemini), (6, 21, .cancer), (7, 23, .leo), (8, 23, .virgo),
        (9, 23, .libra), (10, 23, .scorpio), (11, 22, .sagittarius), (12, 22, .capricorn),
    ]

    static func from(day: Int, month: Int) -> Zodiac? {
        guard (1...12).contains(month), (1...31).contains(day) else { return nil }
        let cutoff = cutoffs[month - 1]
        if day >= cutoff.day { return cutoff.sign }
        // Before the cutoff → the sign that started in the previous month.
        return cutoffs[(month + 10) % 12].sign
    }
}

// MARK: Profile

struct UserProfile: Codable, Equatable {
    var name = ""
    var identity: Identity?
    var birthDay: Int?
    var birthMonth: Int?
    var birthYear: Int?
    var relationship: RelationshipStatus?
    var employment: Employment?
    var countryCode: String?
    var children: ChildrenStatus?
    var interests: Set<String> = []

    var zodiac: Zodiac? {
        guard let birthDay, let birthMonth else { return nil }
        return Zodiac.from(day: birthDay, month: birthMonth)
    }

    /// A profile counts as "created" once the user has saved a name — that's
    /// the only field the rest of the app currently reads.
    var isCreated: Bool { !name.trimmingCharacters(in: .whitespaces).isEmpty }
}

@Observable
final class UserProfileStore {
    private static let key = "profile.v1"

    private(set) var profile: UserProfile

    init() {
        if let data = UserDefaults.standard.data(forKey: Self.key),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
            profile = decoded
        } else {
            profile = UserProfile()
        }
    }

    func save(_ new: UserProfile) {
        profile = new
        if let data = try? JSONEncoder().encode(new) {
            UserDefaults.standard.set(data, forKey: Self.key)
        }
    }

    func deleteAccount() {
        profile = UserProfile()
        UserDefaults.standard.removeObject(forKey: Self.key)
    }
}
