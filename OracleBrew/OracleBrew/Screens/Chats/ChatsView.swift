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

    private let tabClearance: CGFloat = 96

    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack(alignment: .top) {
                Pigment.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    header
                    if chatStore.threads.isEmpty {
                        emptyState
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 10) {
                                ForEach(chatStore.threads) { thread in
                                    Button { router.path.append(thread) } label: {
                                        ChatThreadRow(thread: thread)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.top, 12)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 4)
                .padding(.bottom, tabClearance)
            }
            .toolbar(.hidden, for: .navigationBar)
            .waypointDestinations(router)
            .navigationDestination(for: ChatThread.self) { thread in
                OracleChatView(thread: thread, userName: "Susan", onClose: router.pop)
            }
        }
        .environment(router)
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
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 36))
                .foregroundStyle(Pigment.cream.opacity(0.3))
            Text("chats.empty")
                .font(Lettering.body(14))
                .foregroundStyle(Pigment.cream.opacity(0.4))
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
