//
//  HistoryView.swift
//  OracleBrew
//
//  Tab 3 — archive of past Brew Reading sessions. Tapping a card replays the
//  same stored Reading (not a re-roll) and can resume that oracle's chat.
//

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
                    if historyStore.sessions.isEmpty {
                        emptyState
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 10) {
                                ForEach(historyStore.sessions) { session in
                                    Button { router.path.append(session) } label: {
                                        HistoryCard(session: session)
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
            .navigationDestination(for: ReadingSession.self) { session in
                ReadingResultView(
                    existingReading: session.reading,
                    onAskOracle: {
                        router.path.append(chatStore.thread(for: session.teller, context: makeDraft(session)))
                    },
                    onClose: router.pop
                )
                .environment(makeDraft(session))
            }
            .navigationDestination(for: ChatThread.self) { thread in
                OracleChatView(thread: thread, userName: "Susan", onClose: router.pop)
            }
        }
        .environment(router)
    }

    private func makeDraft(_ session: ReadingSession) -> ReadingDraft {
        let draft = ReadingDraft()
        draft.drink = session.drink
        draft.teller = session.teller
        draft.topic = session.topic
        draft.horizon = session.horizon
        draft.photo = session.photo
        draft.historySessionID = session.id
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

    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 36))
                .foregroundStyle(Pigment.cream.opacity(0.3))
            Text("history.empty")
                .font(Lettering.body(14))
                .foregroundStyle(Pigment.cream.opacity(0.4))
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
