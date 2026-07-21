import AVFoundation
import SwiftUI

/// A bare `AVPlayerLayer` in a SwiftUI view.
///
/// Not SwiftUI's `VideoPlayer` — that one ships playback controls and its own
/// black background, neither of which belongs on a splash screen.
struct VideoLayerView: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        view.backgroundColor = .clear
        view.playerLayer.player = player
        view.playerLayer.videoGravity = .resizeAspect
        return view
    }

    func updateUIView(_ view: PlayerView, context: Context) {
        view.playerLayer.player = player
    }

    final class PlayerView: UIView {
        override static var layerClass: AnyClass { AVPlayerLayer.self }
        var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
    }
}
