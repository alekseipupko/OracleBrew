//
//  ChatsView.swift
//  OracleBrew
//
//  Tab 2 — live oracle conversations, resumable from either entry point
//  (a reading's "Ask Your Oracle", or Oracle Chat picked directly).
//

import SwiftUI

struct ChatsView: View {
    @Environment(ChatSessionStore.self) private var chatStore
    @Bindable var router: Pathfinder

    @State private var showChatFlow = false
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
            .navigationDestination(for: ChatSummary.self) { summary in
                let thread = chatStore.thread(for: summary)
                OracleChatView(thread: thread, userName: "Susan", onClose: router.pop,
                               onOpenProfile: { router.path.append(TellerPeek(teller: thread.teller)) })
            }
            .navigationDestination(for: ChatThread.self) { thread in
                OracleChatView(thread: thread, userName: "Susan", onClose: router.pop,
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
        .task { await chatStore.loadList() }
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
            LazyVStack(spacing: 10) {
                ForEach(items) { summary in
                    Button { router.path.append(summary) } label: {
                        ChatThreadRow(summary: summary)
                    }
                    .buttonStyle(.plain)
                    .task { await chatStore.loadMoreIfNeeded(currentItem: summary) }
                }
                if chatStore.isLoadingMore {
                    ProgressView().tint(Pigment.accent).padding(.vertical, 12)
                }
            }
            .padding(.top, 12)
        }
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
            VStack(alignment: .leading, spacing: 4) {
                Text("tab.chats")
                    .font(Lettering.displayMedium(24))
                    .foregroundStyle(Pigment.cream)
                Text("chats.subtitle")
                    .font(Lettering.body(12))
                    .foregroundStyle(Pigment.creamDim)
            }
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
