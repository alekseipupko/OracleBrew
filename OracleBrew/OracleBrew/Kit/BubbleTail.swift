//
//  BubbleTail.swift
//  OracleBrew
//
//  The chat bubble's tail, traced from the design's slice rather than
//  approximated: the curve swells away from the bubble before hooking back to a
//  point, which a triangle can't do. One shape for both the oracle chat and the
//  onboarding — the design draws them the same.
//

import SwiftUI

/// Drawn leading (tip bottom-left, for the oracle) and mirrored for the user.
struct BubbleTail: Shape {
    let leading: Bool

    /// The slice's own viewBox — the path below is in these coordinates.
    static let size = CGSize(width: 16.4172, height: 20.3225)

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0.112427, y: 20.1846))
        path.addCurve(to: CGPoint(x: 12.1124, y: 16.2879),
                      control1: CGPoint(x: 5.31243, y: 20.9846),
                      control2: CGPoint(x: 10.4458, y: 18.1212))
        path.addCurve(to: CGPoint(x: 14.0003, y: 2.24148),
                      control1: CGPoint(x: 10.3946, y: 12.1914),
                      control2: CGPoint(x: 21.0003, y: 2.24186))
        path.addCurve(to: CGPoint(x: 5.11242, y: 1.1846),
                      control1: CGPoint(x: 12.3817, y: 2.24148),
                      control2: CGPoint(x: 10.9993, y: -1.9986))
        path.addCurve(to: CGPoint(x: 5.11242, y: 7.6842),
                      control1: CGPoint(x: 5.09122, y: 2.47144),
                      control2: CGPoint(x: 5.11242, y: 6.92582))
        path.addCurve(to: CGPoint(x: 0.112427, y: 20.1846),
                      control1: CGPoint(x: 5.11242, y: 18.1842),
                      control2: CGPoint(x: -0.887573, y: 19.5813))
        path.closeSubpath()

        var transform = CGAffineTransform(scaleX: rect.width / Self.size.width,
                                          y: rect.height / Self.size.height)
        if !leading {
            transform = transform.concatenating(
                CGAffineTransform(scaleX: -1, y: 1).translatedBy(x: -rect.width, y: 0)
            )
        }
        return path.applying(transform).offsetBy(dx: rect.minX, dy: rect.minY)
    }
}
