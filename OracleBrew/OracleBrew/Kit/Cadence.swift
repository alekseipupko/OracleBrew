import SwiftUI
import UIKit

enum Cadence {
    /// Standard screen side inset.
    static let sidePadding: CGFloat = 24

    // Radii
    static let cardRadius: CGFloat = 16
    static let pill: CGFloat = 100

    // Cards (Brew Reading / Oracle Chat)
    static let cardHeight: CGFloat = 180
    static let cardInset: CGFloat = 20
    static let cardGap: CGFloat = 20

    // Tab bar (inset is on top of the safe-area bottom, which already covers the home indicator)
    static let tabBarHeight: CGFloat = 69
    static let tabBarInset: CGFloat = 12
    static let tabBarSidePadding: CGFloat = 24

    // Icon hit target (HIG minimum).
    static let tapTarget: CGFloat = 44
}

/// Height-based scale for vertical rhythm. Design frame height = 852 (iPhone Pro).
/// Use for vertical paddings/heights only, never for widths (SE is as wide as Pro).
enum Screen {
    static let designHeight: CGFloat = 852
    static var scale: CGFloat { UIScreen.main.bounds.height / designHeight }
    /// Clamped so tall/short extremes don't distort.
    static var vScale: CGFloat { min(max(scale, 0.82), 1.0) }
}
