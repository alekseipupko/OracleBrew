//
//  DrinkCard.swift
//  OracleBrew
//

import SwiftUI

struct DrinkCard: View {
    let drink: Drink
    let isSelected: Bool
    let dimmed: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) { card }
            .buttonStyle(.plain)
            .opacity(dimmed ? 0.4 : 1)
            .animation(.easeInOut(duration: 0.15), value: dimmed)
    }

    private var card: some View {
        VStack(spacing: 12) {
            photo
            VStack(spacing: 4) {
                Text(drink.name)
                    .font(Lettering.displayMedium(18))
                    .foregroundStyle(Pigment.cream)
                Text(drink.blurb)
                    .font(Lettering.body(12))
                    .foregroundStyle(Pigment.cream.opacity(0.4))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(colors: drink.gradient, startPoint: .top, endPoint: .bottom)
        )
        .overlay(alignment: .topLeading) {
            if drink.isRandom { ribbon }
        }
        .clipShape(RoundedRectangle(cornerRadius: Cadence.cardRadius))
        .overlay(
            RoundedRectangle(cornerRadius: Cadence.cardRadius)
                .strokeBorder(
                    isSelected ? Pigment.accent : Color.white.opacity(0.1),
                    lineWidth: 2
                )
        )
    }

    @ViewBuilder
    private var photo: some View {
        Group {
            // Prefer the API image; fall back to the bundled art (slug-mapped)
            // while the backend serves image: null.
            if let url = drink.imageURL, !url.isEmpty {
                RemoteImage(urlString: url, cornerRadius: Cadence.cardRadius)
            } else {
                Image(drink.art)
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(height: 108)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: Cadence.cardRadius))
        .allowsHitTesting(false)
    }

    private var radio: some View {
        ZStack {
            Circle()
                .strokeBorder(Color.white.opacity(0.15), lineWidth: 2)
                .frame(width: 24, height: 24)
            if isSelected {
                Circle().fill(Pigment.accent).frame(width: 24, height: 24)
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Pigment.cream)
            }
        }
        .padding(10)
    }

    private var ribbon: some View {
        Text("drink.photo_included")
            .font(.custom("JosefinSans-Medium", size: 11))
            .foregroundStyle(Pigment.cream)
            .padding(.horizontal, 30)
            .padding(.vertical, 4)
            .background(Pigment.accentGradient)
            .rotationEffect(.degrees(-35))
            .offset(x: 2, y: 16)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}
