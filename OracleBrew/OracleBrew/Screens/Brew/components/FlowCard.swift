import SwiftUI

struct FlowCard: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let gradient: LinearGradient
    let art: String
    var height: CGFloat = Cadence.cardHeight
    let action: () -> Void

    var body: some View {
        Button(action: action) { card }
            .buttonStyle(.plain)
    }

    private var card: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: Cadence.cardRadius).fill(gradient)

            // Illustration fills the right side; decorative → no hit-testing.
            // Left edge fades into the card so the artwork's own backdrop
            // doesn't leave a hard vertical seam against the gradient.
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                Image(art)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 190, height: height)
                    .mask(
                        LinearGradient(
                            stops: [
                                .init(color: .clear, location: 0),
                                .init(color: .black, location: 0.18)
                            ],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .allowsHitTesting(false)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(Lettering.displayMedium(24))
                    .foregroundStyle(Pigment.cardInk)
                Text(subtitle)
                    .font(Lettering.body(12))
                    .foregroundStyle(Pigment.cardSubtitle)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: 160, alignment: .leading)
                Spacer(minLength: 8)
                arrowBadge
            }
            .padding(18)
        }
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: Cadence.cardRadius))
        .contentShape(RoundedRectangle(cornerRadius: Cadence.cardRadius))
    }

    /// Decorative CTA affordance — the whole card is the tap target.
    private var arrowBadge: some View {
        Image(systemName: "arrow.right")
            .font(.system(size: 18, weight: .medium))
            .foregroundStyle(.white)
            .frame(width: 36, height: 36)
            .background(Circle().fill(Pigment.accentSoft))
    }
}
