import SwiftUI

struct HistoryItem: Identifiable, Hashable {
    let id: Int                 // server reading id
    let drink: Drink
    let teller: FortuneTeller
    let topic: Topic?
    let cupImageURL: String?
    let preview: String
    let adviceHeadline: String
    let timeframe: String
    let hasChat: Bool
    let date: Date

    static func == (lhs: HistoryItem, rhs: HistoryItem) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

@MainActor
@Observable
final class ReadingHistoryStore {
    private(set) var phase: ScreenPhase<[HistoryItem]> = .loading
    private(set) var items: [HistoryItem] = []
    private(set) var isLoadingMore = false

    private var nextPage = 1
    private var canLoadMore = true
    private let repository: HistoryRepository

    init(repository: HistoryRepository = HistoryRepository()) {
        self.repository = repository
    }

    func loadFirst() async {
        nextPage = 1
        canLoadMore = true
        items = []
        phase = .loading
        await fetchNextPage(replacing: true)
    }

    func loadMoreIfNeeded(currentItem: HistoryItem) async {
        guard canLoadMore, !isLoadingMore, currentItem.id == items.last?.id else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }
        await fetchNextPage(replacing: false)
    }

    /// Pulls the full reading for a history row so the Result screen can replay it.
    func reading(for item: HistoryItem) async -> Reading? {
        try? await repository.readingDetail(id: item.id)
    }

    private func fetchNextPage(replacing: Bool) async {
        do {
            let page = try await repository.page(nextPage)
            let mapped = page.results.map(HistoryMapper.item)
            items = replacing ? mapped : items + mapped
            canLoadMore = page.hasMore
            nextPage += 1
            phase = .content(items)
        } catch let failure as EmissaryFailure {
            if replacing { phase = .from(failure) }
        } catch {
            if replacing { phase = .loadFailure }
        }
    }
}
