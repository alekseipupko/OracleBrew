//
//  ScreenStateView.swift
//  OracleBrew
//
//  The load-failure / offline states for any network-backed screen, in the
//  app's own style (no system placeholders). Distinguishes "no connection"
//  from "failed to load" and offers a Retry.
//

import SwiftUI

struct ScreenStateView: View {
    enum Kind {
        case failure, offline

        var icon: String {
            switch self {
            case .failure: "sparkles"
            case .offline: "wifi.slash"
            }
        }
        var title: LocalizedStringKey {
            switch self {
            case .failure: "state.failure.title"
            case .offline: "state.offline.title"
            }
        }
        var message: LocalizedStringKey {
            switch self {
            case .failure: "state.failure.message"
            case .offline: "state.offline.message"
            }
        }
    }

    let kind: Kind
    let retry: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            Spacer()
            Image(systemName: kind.icon)
                .font(.system(size: 40))
                .foregroundStyle(Pigment.accent.opacity(0.7))
            Text(kind.title)
                .font(Lettering.displayMedium(20))
                .foregroundStyle(Pigment.cream)
            Text(kind.message)
                .font(Lettering.body(14))
                .foregroundStyle(Pigment.cream.opacity(0.5))
                .multilineTextAlignment(.center)
            Button(action: retry) {
                Text("state.retry")
                    .font(Lettering.displayMedium(15))
                    .foregroundStyle(Pigment.cream)
                    .padding(.horizontal, 28)
                    .frame(height: 44)
                    .background(Capsule().fill(Pigment.accentGradient))
            }
            .buttonStyle(.plain)
            .padding(.top, 4)
            Spacer()
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity)
    }
}
