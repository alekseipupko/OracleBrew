import AVFoundation
import SwiftUI

/// The launch screen: the ball clip, the wordmark, and the two corner glows.
///
/// It also owns the tracking prompt and the app's boot work. The order is
/// deliberate — the screen appears with the clip paused on its first frame, ATT
/// is requested over it, and only once the user has answered does the clip
/// start. Raising the dialog over a playing video looks broken.
///
/// The splash lasts exactly as long as the clip; there is no separate hold.
struct SplashView: View {
    /// Boot work to run behind the clip — the session, catalog and profile.
    let bootstrap: () async -> Void
    let onFinish: () -> Void

    /// Backstop for a clip that never reports finishing (a corrupt file, a
    /// decoder stall). Comfortably longer than the clip, which runs ~5s.
    private static let playbackCap = Duration.seconds(8)
    /// How long the splash holds when the clip is missing altogether.
    private static let fallbackHold = Duration.seconds(1.5)

    @Environment(\.scenePhase) private var scenePhase

    @State private var player = Bundle.main
        .url(forResource: "splash", withExtension: "mp4")
        .map { AVPlayer(url: $0) }
    @State private var started = false

    var body: some View {
        ZStack {
            // The glows overlay the backdrop rather than sitting behind it —
            // behind an opaque gradient they render to nothing.
            Pigment.splashBackdrop
                .overlay(alignment: .topLeading) { topGlow }
                .overlay(alignment: .bottomTrailing) { bottomGlow }

            ball
                .frame(width: 200, height: 200)
                .mask { edgeFade }
                .offset(y: -26)

            VStack {
                Spacer()
                HStack(spacing: 4) {
                    // Verbatim, not a catalog key — the wordmark is the brand
                    // name and reads the same in every locale.
                    Text(verbatim: "Oracle Brew")
                        .font(Lettering.displayMedium(22))
                        .foregroundStyle(Pigment.cream)
                    SparklePair()
                }
                .padding(.bottom, 44)
            }
        }
        .ignoresSafeArea()
        // Keyed on scenePhase because ATT only presents its dialog once the
        // scene is active — asked any earlier the system returns notDetermined
        // without ever showing it, and the prompt is then lost for good.
        .task(id: scenePhase) {
            guard scenePhase == .active, !started else { return }
            started = true

            await Beacon.request()

            // Boot runs under the clip, so the first screen the user touches
            // already has its data. Whichever finishes last decides the exit.
            async let booted: Void = bootstrap()
            await playClip()
            await booted

            onFinish()
        }
    }

    @ViewBuilder
    private var ball: some View {
        if let player {
            VideoLayerView(player: player)
        } else {
            // The clip is bundled, so this only shows if the build lost it.
            Image("Ball").resizable()
        }
    }

    /// The clip has no alpha and its own glow around the ball, so its frame
    /// reads as a lighter square against the backdrop. Fading the edges out
    /// dissolves that seam — a hard circle would only trade it for a crisp one.
    private var edgeFade: some View {
        RadialGradient(
            gradient: Gradient(stops: [
                .init(color: .black, location: 0),
                .init(color: .black, location: 0.62),
                .init(color: .clear, location: 1),
            ]),
            center: .center,
            startRadius: 0,
            endRadius: 100
        )
    }

    /// Plays the clip and returns when it reaches the end.
    private func playClip() async {
        guard let player, let item = player.currentItem else {
            try? await Task.sleep(for: Self.fallbackHold)
            return
        }
        // Muted so a splash never talks over whatever the user is listening to.
        player.isMuted = true
        player.play()

        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                for await _ in NotificationCenter.default.notifications(
                    named: AVPlayerItem.didPlayToEndTimeNotification, object: item
                ) { return }
            }
            group.addTask { try? await Task.sleep(for: Self.playbackCap) }
            await group.next()
            group.cancelAll()
        }
    }

    // Figma draws both glows as a blurred circle inside an oversized frame that
    // hangs off the edge of the screen. The offsets place that frame's origin,
    // so they stay pinned to their corner on any diagonal.
    private var topGlow: some View {
        Circle()
            .fill(Pigment.splashGlowTop)
            .frame(width: 340, height: 340)
            .blur(radius: 110)
            .offset(x: -150, y: -120)
    }

    private var bottomGlow: some View {
        Circle()
            .fill(Pigment.splashGlowBottom)
            .frame(width: 220, height: 220)
            .blur(radius: 55)
            .offset(x: 67, y: -60)
    }
}

#Preview {
    SplashView(bootstrap: {}, onFinish: {})
}
