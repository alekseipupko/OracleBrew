//
//  FortuneTellers.swift
//  OracleBrew
//
//  Fortune-teller roster. Mock/static personas for v1.0 (authored content, to be
//  reviewed/replaced). Modelled as DATA (plain String) — a real backend would
//  supply this per locale, so it deliberately does not go through the String
//  Catalog. Only 4 personas until 10 unique portraits exist.
//

import Foundation

struct Review: Identifiable {
    let id = UUID()
    let author: String
    let stars: Int
    let text: String
}

struct FortuneTeller: Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let title: String
    let portrait: String
    let rating: Double
    let sessions: Int
    let topics: [String]
    let blurb: String   // short one-liner for the list card
    let bio: String     // long "About" text
    let reviews: [Review]

    var reviewCount: Int { reviews.count }

    static func == (lhs: FortuneTeller, rhs: FortuneTeller) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

enum FortuneTellerRoster {
    static let all: [FortuneTeller] = [
        FortuneTeller(
            id: "seline",
            name: "Seline",
            title: "The Moon Seer",
            portrait: "TellerSeline",
            rating: 4.9,
            sessions: 52,
            topics: ["Love", "Family", "Career", "Destiny", "Relationships"],
            blurb: "Ancient wisdom for clarity, insight and guidance on your path.",
            bio: "Seline is known for her deep connection with moon energy, dreams, and hidden emotional signs. Her gift is seeing what people usually keep unspoken: quiet doubts, secret feelings, repeating patterns, and the true meaning behind confusing situations. She is especially powerful in questions about love, personal choices, destiny, and moments when you feel lost between two paths.",
            reviews: [
                Review(author: "Emma R.", stars: 5, text: "Seline's reading felt deeply personal and surprisingly accurate. She noticed things I hadn't even said out loud and helped me understand my situation with much more clarity."),
                Review(author: "Michelle L.", stars: 5, text: "She sees the details others miss. Highly recommend."),
                Review(author: "Selene R.", stars: 4, text: "I didn't expect the reading to feel so specific, but Seline picked up on emotions and details that matched my situation almost perfectly, in a gentle, thoughtful way."),
                Review(author: "Jay T.", stars: 5, text: "Her energy was calm, kind, and very reassuring. I came in confused, but left feeling grounded and more confident about my next step.")
            ]
        ),
        FortuneTeller(
            id: "amara",
            name: "Amara",
            title: "The Grounds Whisperer",
            portrait: "TellerAmara",
            rating: 4.8,
            sessions: 74,
            topics: ["Love", "Money", "Career", "Health", "Relationships"],
            blurb: "Reads the story left in your cup with warmth and honesty.",
            bio: "Amara learned to read coffee grounds at her grandmother's table and has trusted the cup ever since. She looks for the shapes the sediment leaves behind — the roads, the birds, the knots — and translates them into plain, practical guidance. People come to her when they want an answer they can actually use, especially around money, work, and the health of the people they love.",
            reviews: [
                Review(author: "Dana K.", stars: 5, text: "Amara was warm and direct at the same time. She told me what I needed to hear, not just what I wanted to hear."),
                Review(author: "Omar F.", stars: 5, text: "The way she described the shapes in my cup gave me chills. Everything connected."),
                Review(author: "Priya S.", stars: 4, text: "Really practical advice about my job. I left with a clear plan instead of more worry.")
            ]
        ),
        FortuneTeller(
            id: "lyra",
            name: "Lyra",
            title: "The Star Oracle",
            portrait: "TellerLyra",
            rating: 4.9,
            sessions: 63,
            topics: ["Destiny", "Career", "Travel", "Study", "Money"],
            blurb: "Maps your timing by the stars so you move when the moment is right.",
            bio: "Lyra reads the sky the way others read a page. She is drawn to timing — the right moment to leave, to start, to wait — and to the long arcs of destiny that shape a life. Her sessions feel like stepping back to see the whole map: where you are, where the current is carrying you, and the crossings where your choice matters most.",
            reviews: [
                Review(author: "Nina B.", stars: 5, text: "Lyra helped me understand why the timing had felt so off. Suddenly a hard year made sense."),
                Review(author: "Tomas W.", stars: 5, text: "Calm, precise, and weirdly accurate about my move abroad."),
                Review(author: "Ava M.", stars: 5, text: "She gave me the confidence to wait instead of rushing. Best advice I got all year.")
            ]
        ),
        FortuneTeller(
            id: "nadia",
            name: "Nadia",
            title: "The Flame Reader",
            portrait: "TellerNadia",
            rating: 4.7,
            sessions: 41,
            topics: ["Love", "Family", "Health", "Relationships", "Destiny"],
            blurb: "Feels the heat behind your question and speaks straight to the heart.",
            bio: "Nadia works with the warmth of the flame and the feeling under a question rather than the words on top of it. She is gentle but never vague — she names the emotion you have been avoiding and shows you the kinder path through it. People return to her for matters of the heart, family tension, and the quiet worry that keeps them up at night.",
            reviews: [
                Review(author: "Leah C.", stars: 5, text: "Nadia felt like a wise older sister. I cried, then I felt lighter than I had in months."),
                Review(author: "Sam O.", stars: 4, text: "She was honest about a family situation I kept avoiding. Hard to hear, but exactly right."),
                Review(author: "Ivy R.", stars: 5, text: "So warm and reassuring. I left the chat feeling understood.")
            ]
        )
    ]
}
