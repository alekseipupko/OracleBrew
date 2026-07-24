import SwiftUI

struct ChatsView: View {
    @Environment(ChatSessionStore.self) private var chatStore
    @Environment(ReadingHistoryStore.self) private var historyStore
    @Bindable var router: Pathfinder

    @State private var showChatFlow = false
    private let tabClearance: CGFloat = 96
    /// Button height plus the gap under the last row.
    private let newChatClearance: CGFloat = 72

    private var hasChats: Bool {
        if case .content(let items) = chatStore.listPhase { return !items.isEmpty }
        return false
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack(alignment: .top) {
                Pigment.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    header
                        .padding(.horizontal, 20)
                    content
                }
                .padding(.top, 4)
                // The list stops above the CTA rather than scrolling under it —
                // the button is opaque and would clip the last row.
                .padding(.bottom, tabClearance + (hasChats ? newChatClearance : 0))
            }
            .overlay(alignment: .bottom) {
                // Only once there are chats. The empty state carries its own CTA.
                if hasChats {
                    PrimaryButton(title: "chats.new_chat.cta") { showChatFlow = true }
                        .padding(.horizontal, 20)
                        .padding(.bottom, tabClearance)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .waypointDestinations(router)
            .navigationDestination(for: ChatSummary.self) { summary in
                let thread = chatStore.thread(for: summary)
                OracleChatView(thread: thread, onClose: router.pop,
                               onOpenProfile: { router.path.append(TellerPeek(teller: thread.teller)) })
            }
            .navigationDestination(for: ChatThread.self) { thread in
                OracleChatView(thread: thread, onClose: router.pop,
                               onOpenProfile: { router.path.append(TellerPeek(teller: thread.teller)) })
            }
            .navigationDestination(for: TellerPeek.self) { peek in
                TellerProfileView(teller: peek.teller, onBack: router.pop)
            }
        }
        .environment(router)
        .fullScreenCover(isPresented: $showChatFlow) {
            OracleChatEntryFlow {
                showChatFlow = false
                Task { await chatStore.loadList() }
            }
        }
        .task {
            await chatStore.loadList()
            // The rows badge themselves from History's readings.
            if historyStore.items.isEmpty { await historyStore.loadFirst() }
        }
        .onChange(of: router.path.isEmpty) { _, atRoot in
            // Returning to the list — refresh so the unread dot clears (the
            // backend marked the thread read when it was opened).
            if atRoot { Task { await chatStore.loadList() } }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch chatStore.listPhase {
        case .loading:
            loadingState
        case .content(let items):
            if items.isEmpty { emptyState } else { list(items) }
        case .loadFailure, .offline:
            ScreenStateView(
                kind: chatStore.listPhase.isOffline ? .offline : .failure,
                retry: { Task { await chatStore.loadList() } }
            )
        }
    }

    private func list(_ items: [ChatSummary]) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(items) { summary in
                    Button { router.path.append(summary) } label: {
                        ChatThreadRow(summary: summary, cupImageURL: cupImage(for: summary))
                    }
                    .buttonStyle(.plain)
                    .task { await chatStore.loadMoreIfNeeded(currentItem: summary) }
                }
                if chatStore.isLoadingMore {
                    ProgressView().tint(Pigment.accent).padding(.vertical, 12)
                }
            }
            .padding(.top, 12)
            .padding(.horizontal, 12)
        }
    }

    /// The chat list endpoint carries only `reading_id`, so the cup photo comes
    /// from the readings History already holds. Nil until (or unless) that
    /// reading is among the loaded pages — the row falls back to a glyph.
    private func cupImage(for summary: ChatSummary) -> String? {
        guard let readingID = summary.readingID else { return nil }
        return historyStore.items.first { $0.id == readingID }?.cupImageURL
    }

    private var loadingState: some View {
        VStack {
            Spacer()
            ProgressView().tint(Pigment.accent)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private var header: some View {
        HStack(alignment: .top) {
            // The design titles the screen and drops the subtitle.
            Text("chats.title")
                .font(Lettering.displayMedium(24))
                .foregroundStyle(Pigment.cream)
            Spacer()
            SettingsButton()
        }
        .padding(.bottom, 12)
    }

    private var emptyState: some View {
        EmptyState(
            icon: "ellipsis.bubble",
            headline: "chats.empty.title",
            subtitle: "chats.empty.subtitle",
            cta: (title: "chats.empty.cta", action: { showChatFlow = true })
        )
    }
}
