import SwiftUI

struct ShareCard: View {
    let photo: UIImage?
    let advice: String
    let timeframe: String

    static let size = CGSize(width: 900, height: 1600)

    var body: some View {
        ZStack {
            Image("ShareCardBackground")
                .resizable()
                .scaledToFill()

            cupPhoto
                .position(x: Self.size.width / 2, y: 184 + 266)

            Text("share.cup_is_read")
                .font(Lettering.bodyMedium(24))
                .textCase(.uppercase)
                .kerning(1)
                .foregroundStyle(Color.white.opacity(0.4))
                .position(x: Self.size.width / 2, y: 752 + 14)

            // Figma puts this block's top at 921; .position takes a centre, and
            // the block is ~371 tall at the design's three lines.
            advice_
                .frame(width: 780)
                .position(x: Self.size.width / 2, y: 921 + 185)

            watermark
                .position(x: Self.size.width / 2, y: 1444 + 48)
        }
        .frame(width: Self.size.width, height: Self.size.height)
        .background(Pigment.background)
    }

    private var cupPhoto: some View {
        Group {
            if let photo {
                Image(uiImage: photo).resizable().scaledToFill()
            } else {
                Image("SampleCupCard").resizable().scaledToFill()
            }
        }
        .frame(width: 532, height: 532)
        .clipShape(Circle())
        .overlay(Circle().strokeBorder(Pigment.cupRing, lineWidth: 7))
    }

    private var advice_: some View {
        VStack(spacing: 37) {
            Text(advice)
                .font(Lettering.displayMedium(88))
                .lineSpacing(100 - 88)
                .foregroundStyle(Pigment.cream)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Text(timeframe)
                .font(Lettering.bodySemibold(28))
                .foregroundStyle(Pigment.accent)
                .multilineTextAlignment(.center)
        }
    }

    private var watermark: some View {
        HStack(spacing: 16) {
            // The app icon doesn't exist yet — the design ships a checkerboard
            // placeholder here with a note to drop it in once it's drawn.
            RoundedRectangle(cornerRadius: 21)
                .fill(Pigment.surface)
                .frame(width: 96, height: 96)
                .overlay(
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(Pigment.accent)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text("share.brand")
                    .font(Lettering.displaySemibold(36))
                    .foregroundStyle(.white)
                Text("share.tagline")
                    .font(Lettering.body(18))
                    .foregroundStyle(Pigment.cream.opacity(0.4))
            }
        }
    }
}
