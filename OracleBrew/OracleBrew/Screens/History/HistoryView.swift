import SwiftUI

struct HistoryView: View {
    @Environment(ReadingHistoryStore.self) private var historyStore
    @Environment(ChatSessionStore.self) private var chatStore
    @Bindable var router: Pathfinder

    private let tabClearance: CGFloat = 96

    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack(alignment: .top) {
                Pigment.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    header
                    content
                }
                .padding(.horizontal, 20)
                .padding(.top, 4)
                .padding(.bottom, tabClearance)
            }
            .toolbar(.hidden, for: .navigationBar)
            .waypointDestinations(router)
            .navigationDestination(for: HistoryItem.self) { item in
                HistoryReplayView(
                    item: item,
                    onAskOracle: {
                        router.path.append(chatStore.thread(for: item.teller, context: makeDraft(item)))
                    },
                    onClose: router.pop
                )
            }
            .navigationDestination(for: ChatThread.self) { thread in
                OracleChatView(
                    thread: thread,
                    onClose: router.pop,
                    onOpenProfile: { router.path.append(TellerPeek(teller: thread.teller)) },
                    onReturnToReading: router.pop
                )
            }
            .navigationDestination(for: TellerPeek.self) { peek in
                TellerProfileView(teller: peek.teller, onBack: router.pop)
            }
        }
        .environment(router)
        .task { await historyStore.loadFirst() }
    }

    @ViewBuilder
    private var content: some View {
        switch historyStore.phase {
        case .loading:
            loadingState
        case .content(let items):
            if items.isEmpty { emptyState } else { list(items) }
        case .loadFailure, .offline:
            ScreenStateView(
                kind: historyStore.phase.isOffline ? .offline : .failure,
                retry: { Task { await historyStore.loadFirst() } }
            )
        }
    }

    private func list(_ items: [HistoryItem]) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 10) {
                ForEach(items) { item in
                    HistoryCard(item: item, onOpenChat: {
                        router.path.append(chatStore.thread(for: item.teller, context: makeDraft(item)))
                    })
                    .contentShape(Rectangle())
                    .onTapGesture { router.path.append(item) }
                    .task { await historyStore.loadMoreIfNeeded(currentItem: item) }
                }
                if historyStore.isLoadingMore {
                    ProgressView().tint(Pigment.accent).padding(.vertical, 12)
                }
            }
            .padding(.top, 12)
        }
    }

    private func makeDraft(_ item: HistoryItem) -> ReadingDraft {
        let draft = ReadingDraft()
        draft.drink = item.drink
        draft.teller = item.teller
        draft.topic = item.topic
        draft.readingID = item.id
        return draft
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("tab.history")
                    .font(Lettering.displayMedium(24))
                    .foregroundStyle(Pigment.cream)
                Text("history.subtitle")
                    .font(Lettering.body(12))
                    .foregroundStyle(Pigment.creamDim)
            }
            Spacer()
            SettingsButton()
        }
        .padding(.bottom, 12)
    }

    private var loadingState: some View {
        VStack {
            Spacer()
            ProgressView().tint(Pigment.accent)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    // The design only draws the Chats empty state; this mirrors its pattern for
    // History (no CTA — the tab can't start a reading, that lives on Brew).
    private var emptyState: some View {
        EmptyState(
            icon: "book.closed",
            headline: "history.empty.title",
            subtitle: "history.empty.subtitle"
        )
    }
}

/// Fetches the full reading for a history row, then hands it to the Result
/// screen for verbatim replay.
private struct HistoryReplayView: View {
    let item: HistoryItem
    let onAskOracle: () -> Void
    let onClose: () -> Void

    @Environment(ReadingHistoryStore.self) private var historyStore
    @State private var reading: Reading?
    @State private var failed = false

    private var draft: ReadingDraft {
        let draft = ReadingDraft()
        draft.drink = item.drink
        draft.teller = item.teller
        draft.topic = item.topic
        draft.readingID = item.id
        draft.readingHasChat = item.hasChat
        return draft
    }

    var body: some View {
        Group {
            if let reading {
                ReadingResultView(existingReading: reading, onAskOracle: onAskOracle, onClose: onClose)
                    .environment(draft)
            } else if failed {
                ScreenStateView(kind: .failure, retry: { Task { await load() } })
            } else {
                ZStack {
                    Pigment.background.ignoresSafeArea()
                    ProgressView().tint(Pigment.accent)
                }
                .toolbar(.hidden, for: .navigationBar)
            }
        }
        .task { await load() }
    }

    private func load() async {
        failed = false
        if let result = await historyStore.reading(for: item) {
            reading = result
        } else {
            failed = true
        }
    }
}
