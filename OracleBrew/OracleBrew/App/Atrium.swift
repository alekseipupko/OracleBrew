import SwiftUI

struct Atrium: View {
    @State private var tab: RootTab = .brew
    @State private var brewRouter = Pathfinder()
    @State private var chatsRouter = Pathfinder()
    @State private var historyRouter = Pathfinder()
    @State private var chatStore = ChatSessionStore()
    @State private var historyStore = ReadingHistoryStore()
    @State private var profileStore = UserProfileStore()
    @State private var session = SessionGate()
    @State private var catalog = CatalogStore()

    /// Whether onboarding has been through — locally, and only locally. The
    /// backend is told too (onboarding_completed), but that's for their records:
    /// the token lives in the Keychain and outlives a delete, so deferring to
    /// the backend would mean a reinstalled app never offers onboarding again.
    /// UserDefaults goes with the app, which is the behaviour we want.
    @AppStorage("onboardingSeen") private var onboardingSeen = false

    private var showOnboarding: Bool { !onboardingSeen }

    /// The floating tab bar only makes sense at each tab's root — once a tab
    /// pushes a destination, it'd otherwise float on top of that content too
    /// (it's a ZStack sibling, not scoped to any one NavigationStack).
    private var showTabBar: Bool {
        // Onboarding covers the app, but it's a ZStack sibling — the bar would
        // otherwise float over it and stay tappable.
        if showOnboarding { return false }
        return switch tab {
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

            if showOnboarding {
                OnboardingView(store: profileStore) { onboardingSeen = true }
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showOnboarding)
        .environment(chatStore)
        .environment(historyStore)
        .environment(profileStore)
        .environment(session)
        .environment(catalog)
        .task {
            await session.start()
            // Catalog and profile are authed, so they wait for the token
            // guest-signup mints.
            if session.isReady {
                await catalog.refresh()
                await profileStore.load()
                await session.refreshAccess()
            }
        }
    }
}

#Preview {
    Atrium()
}
