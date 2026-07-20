import SwiftUI

struct ReadingLoadingView: View {
    @Environment(ReadingDraft.self) private var draft
    let onDone: () -> Void
    let onFailure: (EmissaryFailure) -> Void

    private let service = ReadingService()

    /// Figma lays the orb out in a 353×353 box; every size below is that box's
    /// coordinate space, scaled from the source SVG's 472.138 viewBox (×0.7477).
    private static let orbSize: CGFloat = 353
    private static let photoSize: CGFloat = 110.3
    private static let dotSize: CGFloat = 13.24
    private static let dotOrbit: CGFloat = 70.6

    /// Design centres the orb 69.5pt above the screen's middle.
    private static let orbCentreOffset: CGFloat = -69.5
    /// Caption sits at y=593 on the design's 852-tall screen, i.e. +192 from
    /// centre. Anchoring to the centre (rather than padding from the top) keeps
    /// it clear of the bottom on a 667-tall SE.
    private static let captionCentreOffset: CGFloat = 192

    @State private var spinning = false

    var body: some View {
        ZStack {
            Pigment.background.ignoresSafeArea()

            orb
                .frame(width: Self.orbSize, height: Self.orbSize)
                .offset(y: Self.orbCentreOffset)

            VStack(spacing: 8) {
                Text("loading.title")
                    .font(Lettering.displayMedium(28))
                    .foregroundStyle(Pigment.cream)
                Text("loading.subtitle")
                    .font(Lettering.body(14))
                    .foregroundStyle(Pigment.cream.opacity(0.5))
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .offset(y: Self.captionCentreOffset)
        }
        .toolbar(.hidden, for: .navigationBar)
        .task {
            spinning = true
            do {
                let (reading, id) = try await service.generate(from: draft)
                draft.reading = reading
                draft.readingID = id
                onDone()
            } catch let failure as EmissaryFailure {
                onFailure(failure)
            } catch {
                onFailure(.server(statusCode: -1))
            }
        }
    }

    private var orb: some View {
        ZStack {
            Circle()
                .fill(Pigment.accent.opacity(0.2))
                .frame(width: 123.7 * 2, height: 123.7 * 2)
                .blur(radius: 26.4)

            Circle()
                .fill(Pigment.accent)
                .frame(width: 74.2 * 2, height: 74.2 * 2)
                .blur(radius: 13.2)
                .opacity(0.1)

            specks

            Circle()
                .strokeBorder(Pigment.accent, lineWidth: 0.82)
                .frame(width: 79.6 * 2, height: 79.6 * 2)
            Circle()
                .strokeBorder(Pigment.accent, lineWidth: 0.41)
                .frame(width: 107 * 2, height: 107 * 2)

            cupPhoto

            dot
                .offset(x: Self.dotOrbit)
                .rotationEffect(.degrees(spinning ? 360 : 0))
                .animation(.linear(duration: 6).repeatForever(autoreverses: false), value: spinning)
        }
    }

    private var cupPhoto: some View {
        Group {
            if let photo = draft.photo {
                Image(uiImage: photo).resizable().scaledToFill()
            } else {
                Image("SampleCupCard").resizable().scaledToFill()
            }
        }
        .frame(width: Self.photoSize, height: Self.photoSize)
        .clipShape(Circle())
        .overlay(Circle().strokeBorder(Pigment.cream.opacity(0.8), lineWidth: 1))
    }

    private var dot: some View {
        Circle()
            .fill(Pigment.cream)
            .frame(width: Self.dotSize, height: Self.dotSize)
            .shadow(color: Pigment.cream.opacity(0.6), radius: 6)
    }

    /// The faint accent flecks scattered around the orb (Figma: Ellipse…Ellipse_6).
    private var specks: some View {
        ZStack {
            speck(r: 2.21, x: -92.2, y: -64.0, opacity: 0.6)
            speck(r: 1.65, x: 100.2, y: -81.1, opacity: 0.4)
            speck(r: 3.31, x: 68.4, y: 68.4, opacity: 0.3)
            speck(r: 1.65, x: -36.6, y: 100.2, opacity: 0.5)
            speck(r: 1.10, x: -48.7, y: -101.4, opacity: 0.4)
            speck(r: 2.21, x: 108.9, y: 18.1, opacity: 0.2)
        }
    }

    private func speck(r: CGFloat, x: CGFloat, y: CGFloat, opacity: Double) -> some View {
        Circle()
            .fill(Pigment.accent)
            .frame(width: r * 2, height: r * 2)
            .opacity(opacity)
            .offset(x: x, y: y)
    }
}
