import SwiftUI

/// A linear gradient defined the way Figma writes one: a CSS-style angle plus
/// stop offsets, resolved against the actual card size.
///
/// SwiftUI's `LinearGradient` takes two `UnitPoint`s, and those are scaled by
/// the view's width and height independently — so a fixed pair (e.g.
/// topLeading→bottomTrailing) draws at the card's corner slope, not at any
/// particular angle. On a wide card that slope is far shallower than the
/// design's 133°, and the darker colour arrives too early because there is no
/// held first stop. This reads the real size each layout and derives the two
/// points so both the angle and the stop offsets match the Figma fill.
struct CardGradient: View {
    struct Spec {
        /// Two colours: the first is the 0% stop, the second the 100% stop.
        let colors: [Color]
        /// Stop locations along the gradient axis, matching `colors`.
        let stops: [CGFloat]
        /// CSS angle in degrees: 0° points up, 90° right, 180° down.
        let angle: Double
    }

    let spec: Spec
    /// Mirror the horizontal component so the light corner stays on the leading
    /// side under RTL, following the card's own flip. Vertical stays put — only
    /// the left/right of the design is language-relative.
    var mirrored: Bool = false

    var body: some View {
        GeometryReader { geo in
            let (start, end) = axis(in: geo.size)
            LinearGradient(
                stops: zip(spec.colors, spec.stops).map { .init(color: $0, location: $1) },
                startPoint: start,
                endPoint: end
            )
        }
    }

    /// The gradient axis as SwiftUI UnitPoints.
    ///
    /// CSS lays the axis through the centre, long enough that lines drawn
    /// perpendicular to it through the two farthest corners touch its ends — so
    /// its length is `|W·sinθ| + |H·cosθ|`. Placing 0%/100% at those ends is
    /// what makes the stop percentages land where the design put them. The
    /// direction (sinθ, −cosθ) is in screen space (y down); the points are then
    /// normalised by the card's own width and height.
    private func axis(in size: CGSize) -> (UnitPoint, UnitPoint) {
        let radians = spec.angle * .pi / 180
        let dx = (mirrored ? -1 : 1) * sin(radians)
        let dy = -cos(radians)
        let half = (abs(size.width * dx) + abs(size.height * dy)) / 2
        let cx = size.width / 2
        let cy = size.height / 2
        let start = UnitPoint(x: (cx - half * dx) / size.width,
                              y: (cy - half * dy) / size.height)
        let end = UnitPoint(x: (cx + half * dx) / size.width,
                            y: (cy + half * dy) / size.height)
        return (start, end)
    }
}
