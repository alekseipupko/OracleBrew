//
//  TellerCard.swift
//  OracleBrew
//

import SwiftUI

struct TellerCard: View {
    let teller: FortuneTeller
    let isSelected: Bool
    /// Another oracle is picked — this one recedes.
    var dimmed: Bool = false
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
                    .strokeBorder(Color.white.opacity(0.1), lineWidth: 2)
            )
            // Pins the interaction and accessibility frame to the card itself.
            // Without it the union of the children — the portrait fills wider
            // than its clip — reports a frame starting off the left edge.
            .contentShape(RoundedRectangle(cornerRadius: Cadence.cardRadius))
        }
        .buttonStyle(.plain)
        // The design drops the unpicked oracles to 30%.
        .opacity(dimmed ? 0.3 : 1)
        .animation(.easeInOut(duration: 0.15), value: dimmed)
    }

    private var portrait: some View {
        HStack(spacing: 0) {
            // Backing shape is the size root; the image fills it as an overlay and
            // is clipped — keeps scaledToFill's width from driving the card's frame (§5.1).
            Color.clear
                .frame(width: 132, height: 204)
                .overlay {
                    if let url = teller.portraitURL, !url.isEmpty {
                        RemoteImage(urlString: url, cornerRadius: 0)
                    } else {
                        Image(teller.portrait).resizable().scaledToFill()
                    }
                }
                .clipShape(Rectangle())
                .overlay(alignment: .trailing) {
                    LinearGradient(
                        colors: [fadeColor.opacity(0), fadeColor],
                        startPoint: .leading, endPoint: .trailing
                    )
                    .frame(width: 53)
                }
            Spacer(minLength: 0)
        }
        .allowsHitTesting(false)
        // Decorative. Without this the portrait's scaledToFill overflow is
        // unioned into the card's accessibility frame, which then starts ~16pt
        // off the left edge — the drawing is clipped, the a11y rect wasn't.
        .accessibilityHidden(true)
    }

    /// Figma: a 193×164 text block at (142, 18) — the button sits at its
    /// bottom, so the card's own bottom inset (204 − 18 − 164 = 22) falls out
    /// of the fixed height rather than being padded in by hand.
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

            VStack(alignment: .leading, spacing: 6) {
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
            }

            Spacer(minLength: 0)
            viewProfileButton
        }
        .frame(height: 164, alignment: .top)
        .padding(.leading, 142)
        .padding(.trailing, 18)
        .padding(.top, 18)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
                .font(Lettering.body(8))
                .foregroundStyle(Pigment.accent)
                .frame(maxWidth: .infinity)
                .frame(height: 24)
                .background(Capsule().fill(Pigment.accent.opacity(0.15)))
                // 24pt tall in the design; the hit area reaches the 44pt
                // minimum without the pill growing.
                .frame(height: Cadence.tapTarget)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var radio: some View {
        ZStack {
            if isSelected {
                Circle().fill(Pigment.accent)
                Image(systemName: "checkmark").font(.system(size: 12, weight: .bold)).foregroundStyle(.white)
            } else {
                Circle().strokeBorder(Pigment.cream.opacity(0.15), lineWidth: 2)
            }
        }
        .frame(width: 24, height: 24)
        // Figma: 24pt dot at (319, 6) on a 353-wide card → 10 from the trailing
        // edge, 6 from the top. Pad the dot itself before stretching — padding
        // after .frame(maxWidth: .infinity) grows the block past the card and
        // clips the dot.
        .padding(.top, 6)
        .padding(.trailing, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .allowsHitTesting(false)
    }
}
