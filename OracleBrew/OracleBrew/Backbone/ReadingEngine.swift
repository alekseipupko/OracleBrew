import Foundation

struct ReadingSymbol: Identifiable {
    let id = UUID()
    let name: String
    let keyword: String     // short tag, e.g. "Success"
    let meaning: String     // longer explanation
}

struct Reading {
    let symbols: [ReadingSymbol]
    let whatISee: String
    let advice: String
    let timeframe: String
}

enum ReadingEngine {
    private static let bank: [ReadingSymbol] = [
        ReadingSymbol(name: "Sun", keyword: "Success",
            meaning: "The Sun symbolizes achievement, confidence, and positive outcomes. It often appears when a difficult phase is ending and things are starting to move in your favor."),
        ReadingSymbol(name: "Bird", keyword: "News",
            meaning: "The Bird represents messages, conversations, and important updates. It suggests that information is on its way and that communication may play a key role ahead."),
        ReadingSymbol(name: "Star", keyword: "Luck",
            meaning: "The Star is a symbol of luck, hope, and guidance. It indicates that opportunities are aligning in your favor and that your goals may be closer than they seem."),
        ReadingSymbol(name: "Snowflake", keyword: "Delay",
            meaning: "The Snowflake represents patience, timing, and natural development. Some situations need time to unfold — trust the process rather than forcing results."),
        ReadingSymbol(name: "Anchor", keyword: "Stability",
            meaning: "The Anchor points to steadiness and commitment. Something in your life is finding solid ground, even if the surrounding waters still feel uncertain."),
        ReadingSymbol(name: "Key", keyword: "Answers",
            meaning: "The Key signals that something previously locked is about to open — an answer, an opportunity, or a decision that finally becomes clear."),
        ReadingSymbol(name: "Tree", keyword: "Growth",
            meaning: "The Tree reflects steady, rooted growth. What you've been building takes time, but the foundation is sound and getting stronger."),
        ReadingSymbol(name: "Mountain", keyword: "Challenge",
            meaning: "The Mountain marks an obstacle worth climbing. The path may be demanding, but what's on the other side is worth the effort.")
    ]

    private static let advicePool: [String: String] = [
        "love": "Someone you've been waiting on is getting closer to showing their hand",
        "family": "A quiet conversation will clear more than you expect it to",
        "career": "The move you've been hesitating on is safer than it feels",
        "money": "A decision about resources is closer than it appears — review it soon",
        "money_alt": "Patience with finances now pays off sooner than expected",
        "self_growth": "You're closer to the version of yourself you're reaching for",
        "destiny": "The path is clearer than it looks from where you're standing",
        "default": "Something you've been waiting for is getting closer"
    ]

    static func generate(from draft: ReadingDraft) -> Reading {
        let seed = abs((draft.drink?.id ?? "").hashValue ^ (draft.teller?.id ?? "").hashValue ^ (draft.topic?.id ?? "").hashValue)
        var generator = SeededGenerator(seed: UInt64(seed))
        let symbols = Array(bank.shuffled(using: &generator).prefix(4))

        let names = symbols.map(\.name)
        let joined = names.count > 1
            ? names.dropLast().joined(separator: ", ") + " and " + names.last!
            : (names.first ?? "")
        let whatISee = "The cup reveals a powerful combination of \(joined). Together, these symbols suggest that uncertainty is fading and a clearer path is beginning to emerge. Positive developments are forming around you, but some outcomes will depend on timing and patience. This combination points to good news, favorable opportunities, and growing clarity, with the reminder that the best outcomes come to those who allow the right timing to work in their favor."

        let advice = advicePool[draft.topic?.id ?? ""] ?? advicePool["default"]!

        let timeframe: String = switch draft.horizon {
        case .days: "Next few days"
        case .month: "Next 1-2 weeks"
        case .year: "Within the year"
        }

        return Reading(symbols: symbols, whatISee: whatISee, advice: advice, timeframe: timeframe)
    }
}

/// Deterministic shuffle so the same draft (drink+teller+topic) gives a stable
/// reading within a session, without needing to persist the result separately.
private struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) { state = seed == 0 ? 0x9E3779B97F4A7C15 : seed }
    mutating func next() -> UInt64 {
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return state
    }
}
