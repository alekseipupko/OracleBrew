import UIKit

/// The oracle copy and art the app ships with, keyed by the backend's slug.
///
/// The backend owns the oracle as an entity — its id is what a chat and a
/// reading are created against, and its own name and bio drive the AI's
/// persona. What it does not own is presentation: this is the localized copy
/// and the artwork, matched onto whatever the catalog returns.
///
/// Matched on `slug` rather than `id` deliberately: the id is the backend's
/// primary key and would have to be shipped back to us and hardcoded here,
/// whereas the slug is content we agree on once.
struct OracleContent {
    let name: String
    let profession: String
    let shortDescription: String
    let bio: String
    let rating: Double
    let sessions: Int
    let reviewCount: Int
    let topics: [String]
    let reviews: [Review]
    /// Asset name. Falls back to the backend's illustration until the art lands.
    let portrait: String
    /// Suggested questions shown in a chat with this oracle. Empty until the
    /// copy is written, in which case the backend's English set is used.
    var quickPrompts: [String] = []

    /// True once the artwork for this oracle is actually in the bundle — before
    /// then the remote illustration is the better picture to show.
    var hasArtwork: Bool { UIImage(named: portrait) != nil }
}

enum OracleContentCatalog {
    static func content(forSlug slug: String) -> OracleContent? { all[slug] }

    static let all: [String: OracleContent] = [
        "serena": OracleContent(
            name: String(localized: "oracle.serena.name"),
            profession: String(localized: "oracle.serena.profession"),
            shortDescription: String(localized: "oracle.serena.short"),
            bio: String(localized: "oracle.serena.bio"),
            rating: 4.9,
            sessions: 77,
            reviewCount: 36,
            topics: [String(localized: "oracle.topic.love"), String(localized: "oracle.topic.personal_growth"), String(localized: "oracle.topic.life_crossroads"), String(localized: "oracle.topic.emotional_healing")],
            reviews: [
                Review(author: "Emma R.", stars: 5, text: String(localized: "oracle.serena.review.1")),
                Review(author: "Michelle L.", stars: 5, text: String(localized: "oracle.serena.review.2")),
                Review(author: "Sarah K.", stars: 5, text: String(localized: "oracle.serena.review.3")),
                Review(author: "Jay T.", stars: 5, text: String(localized: "oracle.serena.review.4")),
            ],
            portrait: "Serena",
            quickPrompts: [String(localized: "oracle.serena.prompt.1"), String(localized: "oracle.serena.prompt.2"), String(localized: "oracle.serena.prompt.3")]
        ),
        "orion": OracleContent(
            name: String(localized: "oracle.orion.name"),
            profession: String(localized: "oracle.orion.profession"),
            shortDescription: String(localized: "oracle.orion.short"),
            bio: String(localized: "oracle.orion.bio"),
            rating: 4.8,
            sessions: 135,
            reviewCount: 54,
            topics: [String(localized: "oracle.topic.destiny"), String(localized: "oracle.topic.career"), String(localized: "oracle.topic.purpose"), String(localized: "oracle.topic.life_transitions")],
            reviews: [
                Review(author: "Natalie B.", stars: 5, text: String(localized: "oracle.orion.review.1")),
                Review(author: "David W.", stars: 5, text: String(localized: "oracle.orion.review.2")),
                Review(author: "Rachel P.", stars: 5, text: String(localized: "oracle.orion.review.3")),
                Review(author: "Marcus L.", stars: 5, text: String(localized: "oracle.orion.review.4")),
            ],
            portrait: "Orion",
            quickPrompts: [String(localized: "oracle.orion.prompt.1"), String(localized: "oracle.orion.prompt.2"), String(localized: "oracle.orion.prompt.3")]
        ),
        "aurora": OracleContent(
            name: String(localized: "oracle.aurora.name"),
            profession: String(localized: "oracle.aurora.profession"),
            shortDescription: String(localized: "oracle.aurora.short"),
            bio: String(localized: "oracle.aurora.bio"),
            rating: 4.9,
            sessions: 221,
            reviewCount: 167,
            topics: [String(localized: "oracle.topic.dreams"), String(localized: "oracle.topic.intuition"), String(localized: "oracle.topic.emotional_healing"), String(localized: "oracle.topic.subconscious")],
            reviews: [
                Review(author: "Jessica M.", stars: 5, text: String(localized: "oracle.aurora.review.1")),
                Review(author: "Linda F.", stars: 5, text: String(localized: "oracle.aurora.review.2")),
                Review(author: "Olivia S.", stars: 5, text: String(localized: "oracle.aurora.review.3")),
                Review(author: "Emily G.", stars: 5, text: String(localized: "oracle.aurora.review.4")),
            ],
            portrait: "Aurora",
            quickPrompts: [String(localized: "oracle.aurora.prompt.1"), String(localized: "oracle.aurora.prompt.2"), String(localized: "oracle.aurora.prompt.3")]
        ),
        "raven": OracleContent(
            name: String(localized: "oracle.raven.name"),
            profession: String(localized: "oracle.raven.profession"),
            shortDescription: String(localized: "oracle.raven.short"),
            bio: String(localized: "oracle.raven.bio"),
            rating: 4.8,
            sessions: 89,
            reviewCount: 70,
            topics: [String(localized: "oracle.topic.relationships"), String(localized: "oracle.topic.family"), String(localized: "oracle.topic.major_decisions"), String(localized: "oracle.topic.life_changes")],
            reviews: [
                Review(author: "Ashley C.", stars: 5, text: String(localized: "oracle.raven.review.1")),
                Review(author: "Brian T.", stars: 5, text: String(localized: "oracle.raven.review.2")),
                Review(author: "Sophia H.", stars: 5, text: String(localized: "oracle.raven.review.3")),
                Review(author: "Nicole D.", stars: 5, text: String(localized: "oracle.raven.review.4")),
            ],
            portrait: "Raven",
            quickPrompts: [String(localized: "oracle.raven.prompt.1"), String(localized: "oracle.raven.prompt.2"), String(localized: "oracle.raven.prompt.3")]
        ),
        "elias": OracleContent(
            name: String(localized: "oracle.elias.name"),
            profession: String(localized: "oracle.elias.profession"),
            shortDescription: String(localized: "oracle.elias.short"),
            bio: String(localized: "oracle.elias.bio"),
            rating: 5.0,
            sessions: 245,
            reviewCount: 120,
            topics: [String(localized: "oracle.topic.spiritual_growth"), String(localized: "oracle.topic.healing"), String(localized: "oracle.topic.life_purpose"), String(localized: "oracle.topic.difficult_decisions")],
            reviews: [
                Review(author: "Amanda J.", stars: 5, text: String(localized: "oracle.elias.review.1")),
                Review(author: "Kevin M.", stars: 5, text: String(localized: "oracle.elias.review.2")),
                Review(author: "Lauren C.", stars: 5, text: String(localized: "oracle.elias.review.3")),
                Review(author: "Daniel R.", stars: 5, text: String(localized: "oracle.elias.review.4")),
            ],
            portrait: "Elias",
            quickPrompts: [String(localized: "oracle.elias.prompt.1"), String(localized: "oracle.elias.prompt.2"), String(localized: "oracle.elias.prompt.3")]
        ),
        "lyra": OracleContent(
            name: String(localized: "oracle.lyra.name"),
            profession: String(localized: "oracle.lyra.profession"),
            shortDescription: String(localized: "oracle.lyra.short"),
            bio: String(localized: "oracle.lyra.bio"),
            rating: 4.9,
            sessions: 203,
            reviewCount: 193,
            topics: [String(localized: "oracle.topic.healing"), String(localized: "oracle.topic.relationships"), String(localized: "oracle.topic.self_discovery"), String(localized: "oracle.topic.transformation")],
            reviews: [
                Review(author: "Olivia W.", stars: 5, text: String(localized: "oracle.lyra.review.1")),
                Review(author: "Megan H.", stars: 5, text: String(localized: "oracle.lyra.review.2")),
                Review(author: "Lauren T.", stars: 5, text: String(localized: "oracle.lyra.review.3")),
                Review(author: "Sophia D.", stars: 5, text: String(localized: "oracle.lyra.review.4")),
            ],
            portrait: "Lyra",
            quickPrompts: [String(localized: "oracle.lyra.prompt.1"), String(localized: "oracle.lyra.prompt.2"), String(localized: "oracle.lyra.prompt.3")]
        ),
        "cassian": OracleContent(
            name: String(localized: "oracle.cassian.name"),
            profession: String(localized: "oracle.cassian.profession"),
            shortDescription: String(localized: "oracle.cassian.short"),
            bio: String(localized: "oracle.cassian.bio"),
            rating: 4.8,
            sessions: 196,
            reviewCount: 122,
            topics: [String(localized: "oracle.topic.career"), String(localized: "oracle.topic.relationships"), String(localized: "oracle.topic.finances"), String(localized: "oracle.topic.life_transitions")],
            reviews: [
                Review(author: "Brian C.", stars: 5, text: String(localized: "oracle.cassian.review.1")),
                Review(author: "Julia P.", stars: 5, text: String(localized: "oracle.cassian.review.2")),
                Review(author: "Ethan G.", stars: 5, text: String(localized: "oracle.cassian.review.3")),
                Review(author: "Nicole A.", stars: 5, text: String(localized: "oracle.cassian.review.4")),
            ],
            portrait: "Cassian",
            quickPrompts: [String(localized: "oracle.cassian.prompt.1"), String(localized: "oracle.cassian.prompt.2"), String(localized: "oracle.cassian.prompt.3")]
        ),
        "elara": OracleContent(
            name: String(localized: "oracle.elara.name"),
            profession: String(localized: "oracle.elara.profession"),
            shortDescription: String(localized: "oracle.elara.short"),
            bio: String(localized: "oracle.elara.bio"),
            rating: 4.9,
            sessions: 79,
            reviewCount: 55,
            topics: [String(localized: "oracle.topic.personal_growth"), String(localized: "oracle.topic.emotional_patterns"), String(localized: "oracle.topic.soul_lessons"), String(localized: "oracle.topic.purpose")],
            reviews: [
                Review(author: "Rebecca F.", stars: 5, text: String(localized: "oracle.elara.review.1")),
                Review(author: "Ashley M.", stars: 5, text: String(localized: "oracle.elara.review.2")),
                Review(author: "Claire S.", stars: 5, text: String(localized: "oracle.elara.review.3")),
                Review(author: "Melissa R.", stars: 5, text: String(localized: "oracle.elara.review.4")),
            ],
            portrait: "Elara",
            quickPrompts: [String(localized: "oracle.elara.prompt.1"), String(localized: "oracle.elara.prompt.2"), String(localized: "oracle.elara.prompt.3")]
        ),
        "nyx": OracleContent(
            name: String(localized: "oracle.nyx.name"),
            profession: String(localized: "oracle.nyx.profession"),
            shortDescription: String(localized: "oracle.nyx.short"),
            bio: String(localized: "oracle.nyx.bio"),
            rating: 4.8,
            sessions: 83,
            reviewCount: 66,
            topics: [String(localized: "oracle.topic.hidden_fears"), String(localized: "oracle.topic.emotional_healing"), String(localized: "oracle.topic.uncertainty"), String(localized: "oracle.topic.self_awareness")],
            reviews: [
                Review(author: "Chloe T.", stars: 5, text: String(localized: "oracle.nyx.review.1")),
                Review(author: "Hannah J.", stars: 5, text: String(localized: "oracle.nyx.review.2")),
                Review(author: "Rachel W.", stars: 5, text: String(localized: "oracle.nyx.review.3")),
                Review(author: "Amber L.", stars: 5, text: String(localized: "oracle.nyx.review.4")),
            ],
            portrait: "Nyx",
            quickPrompts: [String(localized: "oracle.nyx.prompt.1"), String(localized: "oracle.nyx.prompt.2"), String(localized: "oracle.nyx.prompt.3")]
        ),
        "rowan": OracleContent(
            name: String(localized: "oracle.rowan.name"),
            profession: String(localized: "oracle.rowan.profession"),
            shortDescription: String(localized: "oracle.rowan.short"),
            bio: String(localized: "oracle.rowan.bio"),
            rating: 4.9,
            sessions: 144,
            reviewCount: 110,
            topics: [String(localized: "oracle.topic.life_direction"), String(localized: "oracle.topic.resilience"), String(localized: "oracle.topic.career"), String(localized: "oracle.topic.relationships")],
            reviews: [
                Review(author: "Daniel H.", stars: 5, text: String(localized: "oracle.rowan.review.1")),
                Review(author: "Emma B.", stars: 5, text: String(localized: "oracle.rowan.review.2")),
                Review(author: "Michael R.", stars: 5, text: String(localized: "oracle.rowan.review.3")),
                Review(author: "Anna C.", stars: 5, text: String(localized: "oracle.rowan.review.4")),
            ],
            portrait: "Rowan",
            quickPrompts: [String(localized: "oracle.rowan.prompt.1"), String(localized: "oracle.rowan.prompt.2"), String(localized: "oracle.rowan.prompt.3")]
        ),
        "seraphine": OracleContent(
            name: String(localized: "oracle.seraphine.name"),
            profession: String(localized: "oracle.seraphine.profession"),
            shortDescription: String(localized: "oracle.seraphine.short"),
            bio: String(localized: "oracle.seraphine.bio"),
            rating: 5.0,
            sessions: 112,
            reviewCount: 98,
            topics: [String(localized: "oracle.topic.healing"), String(localized: "oracle.topic.relationships"), String(localized: "oracle.topic.family"), String(localized: "oracle.topic.self_worth")],
            reviews: [
                Review(author: "Grace L.", stars: 5, text: String(localized: "oracle.seraphine.review.1")),
                Review(author: "Isabella M.", stars: 5, text: String(localized: "oracle.seraphine.review.2")),
                Review(author: "Emily W.", stars: 5, text: String(localized: "oracle.seraphine.review.3")),
                Review(author: "Kate N.", stars: 5, text: String(localized: "oracle.seraphine.review.4")),
            ],
            portrait: "Seraphine",
            quickPrompts: [String(localized: "oracle.seraphine.prompt.1"), String(localized: "oracle.seraphine.prompt.2"), String(localized: "oracle.seraphine.prompt.3")]
        ),
        "zephyr": OracleContent(
            name: String(localized: "oracle.zephyr.name"),
            profession: String(localized: "oracle.zephyr.profession"),
            shortDescription: String(localized: "oracle.zephyr.short"),
            bio: String(localized: "oracle.zephyr.bio"),
            rating: 4.8,
            sessions: 88,
            reviewCount: 74,
            topics: [String(localized: "oracle.topic.timing"), String(localized: "oracle.topic.opportunities"), String(localized: "oracle.topic.change"), String(localized: "oracle.topic.destiny")],
            reviews: [
                Review(author: "Jacob T.", stars: 5, text: String(localized: "oracle.zephyr.review.1")),
                Review(author: "Emma S.", stars: 5, text: String(localized: "oracle.zephyr.review.2")),
                Review(author: "Liam P.", stars: 5, text: String(localized: "oracle.zephyr.review.3")),
                Review(author: "Sophie R.", stars: 5, text: String(localized: "oracle.zephyr.review.4")),
            ],
            portrait: "Zephyr",
            quickPrompts: [String(localized: "oracle.zephyr.prompt.1"), String(localized: "oracle.zephyr.prompt.2"), String(localized: "oracle.zephyr.prompt.3")]
        ),
        "isolde": OracleContent(
            name: String(localized: "oracle.isolde.name"),
            profession: String(localized: "oracle.isolde.profession"),
            shortDescription: String(localized: "oracle.isolde.short"),
            bio: String(localized: "oracle.isolde.bio"),
            rating: 4.9,
            sessions: 284,
            reviewCount: 140,
            topics: [String(localized: "oracle.topic.love"), String(localized: "oracle.topic.relationships"), String(localized: "oracle.topic.compatibility"), String(localized: "oracle.topic.destiny")],
            reviews: [
                Review(author: "Natalie K.", stars: 5, text: String(localized: "oracle.isolde.review.1")),
                Review(author: "Victoria P.", stars: 5, text: String(localized: "oracle.isolde.review.2")),
                Review(author: "Olivia J.", stars: 5, text: String(localized: "oracle.isolde.review.3")),
                Review(author: "Emma L.", stars: 5, text: String(localized: "oracle.isolde.review.4")),
            ],
            portrait: "Isolde",
            quickPrompts: [String(localized: "oracle.isolde.prompt.1"), String(localized: "oracle.isolde.prompt.2"), String(localized: "oracle.isolde.prompt.3")]
        ),
        "thorne": OracleContent(
            name: String(localized: "oracle.thorne.name"),
            profession: String(localized: "oracle.thorne.profession"),
            shortDescription: String(localized: "oracle.thorne.short"),
            bio: String(localized: "oracle.thorne.bio"),
            rating: 4.9,
            sessions: 182,
            reviewCount: 99,
            topics: [String(localized: "oracle.topic.wisdom"), String(localized: "oracle.topic.life_purpose"), String(localized: "oracle.topic.personal_growth"), String(localized: "oracle.topic.decisions")],
            reviews: [
                Review(author: "Peter G.", stars: 5, text: String(localized: "oracle.thorne.review.1")),
                Review(author: "Susan W.", stars: 5, text: String(localized: "oracle.thorne.review.2")),
                Review(author: "Matthew C.", stars: 5, text: String(localized: "oracle.thorne.review.3")),
                Review(author: "Laura M.", stars: 5, text: String(localized: "oracle.thorne.review.4")),
            ],
            portrait: "Thorne",
            quickPrompts: [String(localized: "oracle.thorne.prompt.1"), String(localized: "oracle.thorne.prompt.2"), String(localized: "oracle.thorne.prompt.3")]
        ),
        "mira": OracleContent(
            name: String(localized: "oracle.mira.name"),
            profession: String(localized: "oracle.mira.profession"),
            shortDescription: String(localized: "oracle.mira.short"),
            bio: String(localized: "oracle.mira.bio"),
            rating: 5.0,
            sessions: 267,
            reviewCount: 230,
            topics: [String(localized: "oracle.topic.destiny"), String(localized: "oracle.topic.opportunities"), String(localized: "oracle.topic.new_beginnings"), String(localized: "oracle.topic.uncertainty")],
            reviews: [
                Review(author: "Charlotte B.", stars: 5, text: String(localized: "oracle.mira.review.1")),
                Review(author: "Emily R.", stars: 5, text: String(localized: "oracle.mira.review.2")),
                Review(author: "Samantha D.", stars: 5, text: String(localized: "oracle.mira.review.3")),
                Review(author: "Jessica T.", stars: 5, text: String(localized: "oracle.mira.review.4")),
            ],
            portrait: "Mira",
            quickPrompts: [String(localized: "oracle.mira.prompt.1"), String(localized: "oracle.mira.prompt.2"), String(localized: "oracle.mira.prompt.3")]
        ),
    ]
}

extension OracleContentCatalog {
    /// The chip sets drawn in the design. Two of the four differ between them:
    /// a chat opened from a reading offers to go deeper into that reading,
    /// while one started from scratch has nothing to point back at.
    ///
    /// Neither is tied to a particular oracle, which is what makes them usable
    /// as the fallback — the backend's own suggestions are English whatever
    /// language was asked for, so an oracle with no bundled copy still gets
    /// translated chips.
    static let readingPrompts: [String] = [
        String(localized: "chat.prompt.reading.1"),
        String(localized: "chat.prompt.reading.2"),
        String(localized: "chat.prompt.reading.3"),
        String(localized: "chat.prompt.reading.4"),
    ]

    static let freshPrompts: [String] = [
        String(localized: "chat.prompt.new.1"),
        String(localized: "chat.prompt.new.2"),
        String(localized: "chat.prompt.new.3"),
        String(localized: "chat.prompt.new.4"),
    ]

    /// The suggestion list for a chat with this oracle.
    ///
    /// Its own copy when we have it — written for that oracle's speciality —
    /// and the design's shared set otherwise. Either way the chips are
    /// translated, and the list is never a mix of the two.
    static func prompts(forSlug slug: String, fromReading: Bool) -> [String] {
        let own = all[slug]?.quickPrompts ?? []
        if !own.isEmpty { return own }
        return fromReading ? readingPrompts : freshPrompts
    }
}
