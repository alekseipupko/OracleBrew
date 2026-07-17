//
//  BrewView.swift
//  OracleBrew
//
//  Tab 1 — home. Header, daily-fortune hero, two flow-entry cards.
//

import SwiftUI

struct BrewView: View {
    @Environment(Pathfinder.self) private var router
    @Environment(UserProfileStore.self) private var profileStore
    @Environment(CatalogStore.self) private var catalog
    @State private var model = BrewModel()
    @State private var showReadingFlow = false
    @State private var showChatFlow = false

    /// The greeting: "Hi <name>!" once the profile has a name, plain "Hi!"
    /// while it's empty (onboarding skipped).
    private var greeting: LocalizedStringKey {
        let name = profileStore.profile.name.trimmingCharacters(in: .whitespaces)
        return name.isEmpty ? "brew.greeting_anon" : "brew.greeting \(name)"
    }

    private var vs: CGFloat { Screen.vScale }
    private var ballSize: CGFloat { 168 * vs }
    private var cardHeight: CGFloat { max(146, 180 * vs) }
    /// Clearance so the last card isn't hidden by the floating tab bar.
    private let tabClearance: CGFloat = 96

    var body: some View {
        ZStack(alignment: .top) {
            Pigment.background.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                hero.padding(.top, 16 * vs)
                cards.padding(.top, 22 * vs)
                Spacer(minLength: 8)
            }
            .padding(.horizontal, 20)
            .padding(.top, 4)
            .padding(.bottom, tabClearance)
        }
        .toolbar(.hidden, for: .navigationBar)
        .fullScreenCover(isPresented: $showReadingFlow) {
            BrewReadingFlow { showReadingFlow = false }
        }
        .fullScreenCover(isPresented: $showChatFlow) {
            OracleChatEntryFlow { showChatFlow = false }
        }
    }

    // MARK: Header

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(greeting)
                        .font(Lettering.displayMedium(24))
                        .foregroundStyle(Pigment.cream)
                    Image(systemName: "sparkles")
                        .font(.system(size: 15))
                        .foregroundStyle(Pigment.accent)
                }
                Text("brew.subtitle")
                    .font(Lettering.body(12))
                    .foregroundStyle(Pigment.creamDim)
            }
            Spacer()
            SettingsButton()
        }
        .padding(.leading, 4)
    }

    // MARK: Hero

    private var hero: some View {
        HStack(alignment: .center, spacing: 12) {
            Image("Ball")
                .resizable()
                .scaledToFill()
                .frame(width: ballSize, height: ballSize)
                .clipShape(Circle())
                .allowsHitTesting(false)
            VStack(alignment: .leading, spacing: 8) {
                Text("brew.daily_fortune")
                    .font(Lettering.bodyMedium(10))
                    .tracking(0.5)
                    .textCase(.uppercase)
                    .foregroundStyle(Pigment.accent)
                Group {
                    // The server's fortune of the day; the bundled line until
                    // it loads (or if the backend has none).
                    if let fortune = catalog.dailyFortune, !fortune.isEmpty {
                        Text(fortune)
                    } else {
                        Text(model.dailyHeadline)
                    }
                }
                .font(Lettering.display(26))
                .foregroundStyle(Pigment.cream)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    // MARK: Cards

    private var cards: some View {
        VStack(spacing: Cadence.cardGap * vs) {
            FlowCard(
                title: "brew.card.reading.title",
                subtitle: "brew.card.reading.subtitle",
                gradient: Pigment.brewCard,
                art: "CupArt",
                height: cardHeight
            ) { showReadingFlow = true }

            FlowCard(
                title: "brew.card.oracle.title",
                subtitle: "brew.card.oracle.subtitle",
                gradient: Pigment.oracleCard,
                art: "TellerArt",
                height: cardHeight
            ) { showChatFlow = true }
        }
    }
}

#Preview {
    @Previewable @State var router = Pathfinder()
    return NavigationStack {
        BrewView().environment(router)
    }
}
