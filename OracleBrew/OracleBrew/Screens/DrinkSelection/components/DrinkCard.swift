import SwiftUI

struct DrinkCard: View {
    let drink: Drink
    let isSelected: Bool
    let dimmed: Bool
    let onTap: () -> Void

    @Environment(\.layoutDirection) private var layoutDirection

    var body: some View {
        Button(action: onTap) { card }
            .buttonStyle(.plain)
            // The design drops everything but the picked drink right down to 20%.
            .opacity(dimmed ? 0.2 : 1)
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
        .overlay {
            // Placed by absolute geometry, not by an alignment: the sash is
            // decoration painted across the artwork, so it stays put whichever
            // way the card reads, and `.position` takes the design's own
            // centre point directly.
            if drink.isRandom {
                ribbon.position(x: Self.ribbonCentre.x, y: Self.ribbonCentre.y)
            }
        }
        .overlay(alignment: .topTrailing) { radio }
        .clipShape(RoundedRectangle(cornerRadius: Cadence.cardRadius))
        .overlay(
            RoundedRectangle(cornerRadius: Cadence.cardRadius)
                .strokeBorder(Color.white.opacity(0.1), lineWidth: 2)
        )
    }

    @ViewBuilder
    private var photo: some View {
        Group {
            // Prefer the API image; fall back to the bundled art (slug-mapped)
            // while the backend serves image: null.
            if let url = drink.imageURL, !url.isEmpty {
                // Clear backing: the art is a cutout, so it has to sit on the
                // card's own gradient — an opaque fill reads as a box around it.
                RemoteImage(urlString: url, cornerRadius: Cadence.cardRadius, backing: .clear)
            } else {
                Image(drink.art)
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(height: 108)
        .frame(maxWidth: .infinity)
        // The design insets the photo 4pt inside the card's own 12pt padding
        // (138 wide in a 170 card); as an inset it holds on wider screens too.
        .padding(.horizontal, 4)
        .clipShape(RoundedRectangle(cornerRadius: Cadence.cardRadius))
        .allowsHitTesting(false)
    }

    private var radio: some View {
        ZStack {
            if isSelected {
                Circle().fill(Pigment.accent)
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
            } else {
                Circle().strokeBorder(Color.white.opacity(0.15), lineWidth: 2)
            }
        }
        .frame(width: 24, height: 24)
        .padding(.top, 6)
        .padding(.trailing, 10)
        .allowsHitTesting(false)
    }

    // The sash, straight off the design. Its size is the band before rotation,
    // solved from the rotated bounding box Figma reports (178.09 x 138.06 at
    // -35°); its centre is where that box sits relative to the card's corner.
    //
    // Fixed rather than sized to the text on purpose: the band is rotated about
    // its own centre, so a width that followed the translation would move where
    // it crosses the corner. The Arabic string is shorter than the English one
    // and used to sit 12pt further into the card. The text centres inside a
    // constant band instead.
    private static let ribbonWidth: CGFloat = 195
    private static let ribbonHeight: CGFloat = 32
    private static let ribbonCentre = CGPoint(x: 44.23, y: 34.42)

    private var ribbon: some View {
        Text("drink.photo_included")
            .font(Lettering.displaySemibold(12))
            .foregroundStyle(Pigment.cream)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .frame(width: Self.ribbonWidth, height: Self.ribbonHeight)
            .background(Pigment.accentGradient)
            .rotationEffect(.degrees(-35))
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}
