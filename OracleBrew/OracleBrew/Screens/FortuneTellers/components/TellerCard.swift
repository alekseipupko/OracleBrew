//
//  TellerCard.swift
//  OracleBrew
//

import SwiftUI

struct TellerCard: View {
    let teller: FortuneTeller
    let isSelected: Bool
    let onSelect: () -> Void
    let onViewProfile: () -> Void

    private let cardColor = Color(hex: 0x271C3E)
    private let fadeColor = Color(hex: 0x2A1B3A)

    var body: some View {
        Button(action: onSelect) {
            ZStack(alignment: .topLeading) {
                cardColor
                portrait
                content
                radio
            }
            .frame(height: 204)
            .clipShape(RoundedRectangle(cornerRadius: Cadence.cardRadius))
            .overlay(
                RoundedRectangle(cornerRadius: Cadence.cardRadius)
                    .strokeBorder(isSelected ? Pigment.accent : Color.white.opacity(0.1), lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }

    private var portrait: some View {
        HStack(spacing: 0) {
            // Backing shape is the size root; the image fills it as an overlay and
            // is clipped — keeps scaledToFill's width from driving the card's frame (§5.1).
            Color.clear
                .frame(width: 132, height: 204)
                .overlay {
                    Image(teller.portrait).resizable().scaledToFill()
                }
                .clipShape(Rectangle())
                .overlay(alignment: .trailing) {
                    LinearGradient(
                        colors: [fadeColor.opacity(0), fadeColor],
                        startPoint: .leading, endPoint: .trailing
                    )
                    .frame(width: 60)
                }
            Spacer(minLength: 0)
        }
        .allowsHitTesting(false)
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 0) {
                Text(teller.name)
                    .font(Lettering.displayMedium(22))
                    .foregroundStyle(Pigment.cream)
                Text(teller.title)
                    .font(Lettering.body(10))
                    .foregroundStyle(Pigment.cream.opacity(0.4))
            }

            HStack(spacing: 12) {
                RatingLabel(rating: teller.rating, starSize: 16, textSize: 12)
                Text("teller.sessions \(teller.sessions)")
                    .font(Lettering.body(10)).foregroundStyle(Pigment.cream.opacity(0.4))
                Text("teller.reviews \(teller.reviewCount)")
                    .font(Lettering.body(10)).foregroundStyle(Pigment.cream.opacity(0.4))
            }

            chipsRow

            Text(teller.blurb)
                .font(Lettering.body(10))
                .foregroundStyle(Pigment.cream.opacity(0.4))
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 6)
            viewProfileButton
        }
        .padding(.leading, 142)
        .padding(.trailing, 18)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// Show as many topic chips as fit (3 → 2 → 1) + a "+N" remainder, never truncating.
    private var chipsRow: some View {
        ViewThatFits(in: .horizontal) {
            chipSet(3)
            chipSet(2)
            chipSet(1)
        }
    }

    private func chipSet(_ count: Int) -> some View {
        HStack(spacing: 4) {
            ForEach(teller.topics.prefix(count), id: \.self) { TopicChip(text: $0, compact: true) }
            if teller.topics.count > count {
                TopicChip(text: "+\(teller.topics.count - count)", compact: true, accent: true)
            }
        }
        .fixedSize()
    }

    private var viewProfileButton: some View {
        Button(action: onViewProfile) {
            Text("teller.view_profile")
                .font(Lettering.body(11))
                .foregroundStyle(Pigment.accent)
                .frame(maxWidth: .infinity)
                .frame(height: 26)
                .background(Capsule().fill(Pigment.accent.opacity(0.15)))
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private var radio: some View {
        ZStack {
            Circle().strokeBorder(Pigment.cream.opacity(0.15), lineWidth: 2).frame(width: 24, height: 24)
            if isSelected {
                Circle().fill(Pigment.accent).frame(width: 24, height: 24)
                Image(systemName: "checkmark").font(.system(size: 12, weight: .bold)).foregroundStyle(Pigment.cream)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(10)
        .allowsHitTesting(false)
    }
}
