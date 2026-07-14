//
//  TabChrome.swift
//  OracleBrew
//
//  The 3 root tabs and the custom floating pill tab bar.
//

import SwiftUI

enum RootTab: CaseIterable {
    case brew, chats, history

    var titleKey: LocalizedStringKey {
        switch self {
        case .brew: "tab.brew"
        case .chats: "tab.chats"
        case .history: "tab.history"
        }
    }

    /// Default (unselected) icon asset. Colors are baked into the artwork.
    var icon: String {
        switch self {
        case .brew: "iconoir_coffee-cup"
        case .chats: "hugeicons_bubble-chat"
        case .history: "history"
        }
    }

    /// Selected variant — same asset name with the `-set` suffix.
    var iconSelected: String { icon + "-set" }
}

struct TabBar: View {
    @Binding var selection: RootTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(RootTab.allCases, id: \.self) { tab in
                Button {
                    selection = tab
                } label: {
                    VStack(spacing: 4) {
                        Image(selection == tab ? tab.iconSelected : tab.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                        Text(tab.titleKey)
                            .font(Lettering.body(11))
                            .foregroundStyle(selection == tab ? Pigment.accent : Pigment.mutedText)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: Cadence.tabBarHeight)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, Cadence.tabBarSidePadding)
        .frame(height: Cadence.tabBarHeight)
        .background(
            Capsule().fill(Pigment.surface)
        )
        .padding(.horizontal, Cadence.sidePadding)
        .padding(.bottom, Cadence.tabBarInset)
    }
}
