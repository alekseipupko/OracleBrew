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

    /// The splash covers the app until the tracking prompt is answered and the
    /// session is up, so nothing underneath is ever seen mid-load. It lifts only
    /// once both are done — whichever finishes last.
    @State private var splashPlayed = false
    @State private var loaded = false

    private var booting: Bool { !splashPlayed || !loaded }

    private var showOnboarding: Bool { !onboardingSeen }

    /// The floating tab bar only makes sense at each tab's root — once a tab
    /// pushes a destination, it'd otherwise float on top of that content too
    /// (it's a ZStack sibling, not scoped to any one NavigationStack).
    private var showTabBar: Bool {
        // Onboarding and the splash cover the app, but they're ZStack siblings —
        // the bar would otherwise float over them and stay tappable.
        if booting || showOnboarding { return false }
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

            if booting {
                SplashView { splashPlayed = true }
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showOnboarding)
        .animation(.easeInOut(duration: 0.35), value: booting)
        .environment(chatStore)
        .environment(historyStore)
        .environment(profileStore)
        .environment(session)
        .environment(catalog)
        // Deliberately not inside the splash: the ATT dialog cycles the scene
        // phase, and a task keyed on that would be cancelled mid-flight — which
        // silently left the catalog on its bundled mocks.
        .task {
            await bootstrap()
            loaded = true
        }
    }

    /// Runs under the splash, so the first screen the user touches already has
    /// its data instead of shimmering into place.
    private func bootstrap() async {
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

#Preview {
    Atrium()
}
