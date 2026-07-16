//
//  ChatSessionStore.swift
//  OracleBrew
//
//  Chats (tab): live conversation state per oracle, shared across every chat
//  entry point so returning to a teller resumes the same thread. In-memory
//  only for v1.0.
//

import Foundation

@Observable
final class ChatThread: Identifiable {
    let id = UUID()
    let teller: FortuneTeller
    /// Reading this chat grew out of, if any — nil for a direct chat entry.
    let draftContext: ReadingDraft?
    var messages: [ChatMessage] = []
    var lastUpdated = Date()
    /// The server chat id, resolved on first open (create-or-resume). Until then
    /// messages haven't been loaded.
    var backendID: Int?
    /// Quick-question chips the server suggests for this thread.
    var quickQuestions: [String] = []

    init(teller: FortuneTeller, draftContext: ReadingDraft?) {
        self.teller = teller
        self.draftContext = draftContext
    }
}

extension ChatThread: Hashable {
    static func == (lhs: ChatThread, rhs: ChatThread) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

@Observable
final class ChatSessionStore {
    private(set) var threads: [ChatThread] = []

    /// Returns the existing thread with this teller, or opens a new one.
    func thread(for teller: FortuneTeller, context: ReadingDraft?) -> ChatThread {
        if let existing = threads.first(where: { $0.teller.id == teller.id }) {
            return existing
        }
        let new = ChatThread(teller: teller, draftContext: context)
        threads.insert(new, at: 0)
        return new
    }
}
