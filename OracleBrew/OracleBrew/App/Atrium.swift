//
//  Atrium.swift
//  OracleBrew
//
//  Root container: 3-tab shell (Brew / Chats / History) with a custom floating
//  pill tab bar. Each tab owns its own NavigationStack + Pathfinder router.
//

import SwiftUI

struct Atrium: View {
    @State private var tab: RootTab = .brew
    @State private var brewRouter = Pathfinder()
    @State private var chatsRouter = Pathfinder()
    @State private var historyRouter = Pathfinder()
    @State private var chatStore = ChatSessionStore()
    @State private var historyStore = ReadingHistoryStore()
    @State private var profileStore = UserProfileStore()

    /// The floating tab bar only makes sense at each tab's root — once a tab
    /// pushes a destination, it'd otherwise float on top of that content too
    /// (it's a ZStack sibling, not scoped to any one NavigationStack).
    private var showTabBar: Bool {
        switch tab {
        case .brew: brewRouter.path.isEmpty
        case .chats: chatsRouter.path.isEmpty
        case .history: historyRouter.path.isEmpty
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Pigment.background.ignoresSafeArea()

            switch tab {
            case .brew:
                NavigationStack(path: $brewRouter.path) {
                    BrewView()
                        .waypointDestinations(brewRouter)
                }
                .environment(brewRouter)
            case .chats:
                ChatsView(router: chatsRouter)
            case .history:
                HistoryView(router: historyRouter)
            }

            if showTabBar {
                TabBar(selection: $tab)
            }
        }
        .environment(chatStore)
        .environment(historyStore)
        .environment(profileStore)
    }
}

#Preview {
    Atrium()
}
