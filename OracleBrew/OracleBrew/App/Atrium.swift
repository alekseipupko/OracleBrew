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
    @State private var profileStore = UserProfileStore()

    var body: some View {
        ZStack(alignment: .bottom) {
            Pigment.background.ignoresSafeArea()

            switch tab {
            case .brew:
                NavigationStack(path: $brewRouter.path) {
                    BrewView()
                        .navigationDestination(for: Waypoint.self) { destination($0) }
                }
                .environment(brewRouter)
            case .chats:
                TabPlaceholder(title: "tab.chats")
            case .history:
                TabPlaceholder(title: "tab.history")
            }

            TabBar(selection: $tab)
        }
        .environment(profileStore)
    }

    @ViewBuilder
    private func destination(_ waypoint: Waypoint) -> some View {
        // Real screens land here as flows are built.
        switch waypoint {
        case .settings: TabPlaceholder(title: "settings.title")
        case .brewReading: TabPlaceholder(title: "flow.brew_reading")
        case .profile:
            ProfileView(onBack: brewRouter.pop, onSaved: brewRouter.pop)
        }
    }
}

/// Temporary stand-in for tabs/flows not yet built.
private struct TabPlaceholder: View {
    let title: LocalizedStringKey
    var body: some View {
        ZStack {
            Pigment.background.ignoresSafeArea()
            Text(title)
                .font(Lettering.displayMedium(24))
                .foregroundStyle(Pigment.cream)
        }
    }
}

#Preview {
    Atrium()
}
