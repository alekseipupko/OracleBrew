//
//  OracleChatEntryFlow.swift
//  OracleBrew
//
//  Direct "Oracle Chat" entry from the Brew tab: pick an oracle, then chat —
//  no reading context, so ChatEngine greets generically. Presented full-screen,
//  mirrors BrewReadingFlow's container pattern.
//

import SwiftUI

private enum ChatEntryStep: Hashable { case chat }

struct OracleChatEntryFlow: View {
    let onClose: () -> Void

    @Environment(ChatSessionStore.self) private var chatStore
    @State private var draft = ReadingDraft()
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            FortuneTellersView(
                onContinue: { path.append(ChatEntryStep.chat) },
                onOpenProfile: { path.append($0) },
                onBack: onClose,
                onClose: onClose
            )
            .navigationDestination(for: FortuneTeller.self) { teller in
                TellerProfileView(
                    teller: teller,
                    onContinue: {
                        draft.teller = teller
                        path.append(ChatEntryStep.chat)
                    },
                    onBack: { if !path.isEmpty { path.removeLast() } }
                )
            }
            .navigationDestination(for: ChatEntryStep.self) { _ in
                if let teller = draft.teller {
                    OracleChatView(thread: chatStore.thread(for: teller, context: nil), userName: "Susan", onClose: onClose)
                }
            }
        }
        .environment(draft)
    }
}
