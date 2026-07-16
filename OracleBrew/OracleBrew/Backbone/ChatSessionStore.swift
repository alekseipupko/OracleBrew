//
//  ChatSessionStore.swift
//  OracleBrew
//
//  Chats (tab): the thread list comes from GET /chats/ (paged); an open thread
//  keeps its live messages in a ChatThread so returning to an oracle resumes
//  the same conversation. Both entry points (a reading's "Ask Your Oracle" and
//  Oracle Chat picked directly) route through the same threads.
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
    /// The server chat id, resolved on first open (create-or-resume) or carried
    /// in from the thread list. Until then messages haven't been loaded.
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

/// A row in the Chats tab — the server's thread summary.
struct ChatSummary: Identifiable, Hashable {
    let id: Int
    let teller: FortuneTeller
    let preview: String
    let date: Date
    /// The oracle sent a message the user hasn't opened yet — shows the dot.
    let hasUnread: Bool
}

@MainActor
@Observable
final class ChatSessionStore {
    private(set) var threads: [ChatThread] = []

    // Thread list (Chats tab)
    private(set) var listPhase: ScreenPhase<[ChatSummary]> = .loading
    private(set) var summaries: [ChatSummary] = []
    private(set) var isLoadingMore = false
    private var nextPage = 1
    private var canLoadMore = true

    private let repository: ChatRepository

    init(repository: ChatRepository = ChatRepository()) {
        self.repository = repository
    }

    // MARK: Open threads

    /// Returns the existing thread with this teller, or opens a new one.
    func thread(for teller: FortuneTeller, context: ReadingDraft?) -> ChatThread {
        if let existing = threads.first(where: { $0.teller.id == teller.id }) {
            return existing
        }
        let new = ChatThread(teller: teller, draftContext: context)
        threads.insert(new, at: 0)
        return new
    }

    /// Opens the thread behind a list row, carrying its known server id so the
    /// chat screen loads messages directly instead of creating a new thread.
    func thread(for summary: ChatSummary) -> ChatThread {
        let thread = self.thread(for: summary.teller, context: nil)
        thread.backendID = summary.id
        return thread
    }

    // MARK: Thread list

    func loadList() async {
        nextPage = 1
        canLoadMore = true
        summaries = []
        listPhase = .loading
        await fetchNextPage(replacing: true)
    }

    func loadMoreIfNeeded(currentItem: ChatSummary) async {
        guard canLoadMore, !isLoadingMore, currentItem.id == summaries.last?.id else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }
        await fetchNextPage(replacing: false)
    }

    private func fetchNextPage(replacing: Bool) async {
        do {
            let page = try await repository.list(page: nextPage)
            let mapped = page.results.map(Self.summary)
            summaries = replacing ? mapped : summaries + mapped
            canLoadMore = page.hasMore
            nextPage += 1
            listPhase = .content(summaries)
        } catch let failure as EmissaryFailure {
            if replacing { listPhase = .from(failure) }
        } catch {
            if replacing { listPhase = .loadFailure }
        }
    }

    private static let isoFormatter = ISO8601DateFormatter()

    private static func summary(_ dto: ChatListItemDTO) -> ChatSummary {
        ChatSummary(
            id: dto.id,
            teller: CatalogMapper.oracle(dto.oracle),
            preview: dto.lastMessage?.text ?? "Say hello to start the conversation",
            date: dto.updatedAt.flatMap { isoFormatter.date(from: $0) } ?? Date(),
            hasUnread: dto.hasUnreadFromOracle ?? false
        )
    }
}
