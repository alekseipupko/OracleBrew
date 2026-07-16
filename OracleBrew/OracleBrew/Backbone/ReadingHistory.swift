//
//  ReadingHistory.swift
//  OracleBrew
//
//  Reading History (tab): archive of past Brew Reading sessions. In-memory
//  only for v1.0 (no Vault/persistence yet) — cleared on app relaunch.
//

import SwiftUI

@Observable
final class ReadingSession: Identifiable {
    let id = UUID()
    let date: Date
    let drink: Drink
    let teller: FortuneTeller
    let topic: Topic?
    let horizon: TimeHorizon
    let photo: UIImage?
    let reading: Reading
    var hasChatted: Bool

    init(date: Date, drink: Drink, teller: FortuneTeller, topic: Topic?, horizon: TimeHorizon,
         photo: UIImage?, reading: Reading, hasChatted: Bool = false) {
        self.date = date
        self.drink = drink
        self.teller = teller
        self.topic = topic
        self.horizon = horizon
        self.photo = photo
        self.reading = reading
        self.hasChatted = hasChatted
    }
}

extension ReadingSession: Hashable {
    static func == (lhs: ReadingSession, rhs: ReadingSession) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

@Observable
final class ReadingHistoryStore {
    private(set) var sessions: [ReadingSession] = []

    @discardableResult
    func record(drink: Drink, teller: FortuneTeller, topic: Topic?, horizon: TimeHorizon,
                photo: UIImage?, reading: Reading) -> ReadingSession {
        let session = ReadingSession(date: Date(), drink: drink, teller: teller, topic: topic,
                                      horizon: horizon, photo: photo, reading: reading)
        sessions.insert(session, at: 0)
        return session
    }

    func markChatted(_ id: UUID) {
        sessions.first { $0.id == id }?.hasChatted = true
    }
}
