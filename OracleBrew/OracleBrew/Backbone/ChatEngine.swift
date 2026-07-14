//
//  ChatEngine.swift
//  OracleBrew
//
//  Oracle Chat — fixed canned replies for v1.0 (mirrors FortuneTellers.swift:
//  authored content, not routed through the String Catalog, since a real
//  backend/AI would supply this later). `reply(to:)` is the protocol boundary
//  a real LLM drops into without touching the chat UI.
//

import Foundation

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let isFromUser: Bool
    let text: String
}

enum ChatEngine {
    static func greeting(teller: FortuneTeller, userName: String, draft: ReadingDraft?) -> String {
        if let topic = draft?.topic {
            return "Welcome back, \(userName). I've been sitting with what your cup showed about \(topic.name.lowercased()) — what's on your mind?"
        }
        return "Hello \(userName), I'm \(teller.name), \(teller.title). \(genericOpeners.randomElement()!)"
    }

    static func quickQuestions(hasReadingContext: Bool) -> [String] {
        hasReadingContext ? readingQuickQuestions : genericQuickQuestions
    }

    static func reply(to text: String, teller: FortuneTeller, draft: ReadingDraft?) -> String {
        let lowered = text.lowercased()
        for pool in keywordPools where pool.keywords.contains(where: lowered.contains) {
            return pool.replies.randomElement()!
        }
        return fallbackPool.randomElement()!
    }

    private static let genericOpeners = [
        "What's weighing on you today?",
        "Ask me anything — the grounds are still speaking.",
        "What would you like to understand better?"
    ]

    private static let readingQuickQuestions = [
        "Can you tell me more about the timing?",
        "What should I be careful about?",
        "How do I make the most of this?",
        "Is there anything else you saw?"
    ]

    private static let genericQuickQuestions = [
        "What do you see for me today?",
        "What should I focus on this week?",
        "Any guidance about love right now?",
        "What is my energy telling you?"
    ]

    private static let keywordPools: [(keywords: [String], replies: [String])] = [
        (["love", "relationship", "partner"], [
            "Love asks patience right now — don't force what hasn't settled yet.",
            "There's a tenderness in your cup around love. Let the other person come to you first.",
            "The symbols point toward honesty. Say the thing you've been holding back."
        ]),
        (["money", "job", "career", "work"], [
            "Money follows steady hands, not rushed ones. Hold your plan a little longer.",
            "Your career line is bending upward — a small, brave choice opens it further.",
            "Don't sign anything out of fear. Wait for the offer that feels calm, not urgent."
        ]),
        (["family", "health"], [
            "Family matters need warmth before words. Sit with them before you speak.",
            "Your body has been asking for rest. Give it a real day off, not a half one.",
            "Old family patterns are surfacing so you can finally close them."
        ]),
        (["time", "when", "soon"], [
            "Not yet, but close — within the season you already sense.",
            "The timing favors waiting one more turn of the moon.",
            "Sooner than you fear, later than you'd like. Stay ready."
        ])
    ]

    private static let fallbackPool = [
        "The grounds don't give a straight answer to that, but they do agree it matters.",
        "Sit with that question a little longer — the answer is already forming in you.",
        "I see movement around that, but nothing settled yet. Ask me again after you decide.",
        "That's between you and the choice in front of you — I can only light the path."
    ]
}
