import SwiftUI

extension Pigment {
    /// Rating star gold.
    static let star = Color(hex: 0xF9C169)
}

/// A single gold rating value: ★ + number.
struct RatingLabel: View {
    let rating: Double
    var starSize: CGFloat = 16
    var textSize: CGFloat = 12

    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "star.fill")
                .font(.system(size: starSize * 0.85))
                .foregroundStyle(Pigment.star)
            Text(rating.formatted(.number.precision(.fractionLength(1))))
                .font(Lettering.body(textSize))
                .foregroundStyle(Pigment.star)
        }
    }
}

/// A row of five stars, `filled` of them gold.
struct StarRow: View {
    let filled: Int
    var size: CGFloat = 20

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<5, id: \.self) { i in
                Image(systemName: "star.fill")
                    .font(.system(size: size * 0.85))
                    .foregroundStyle(i < filled ? Pigment.star : Pigment.star.opacity(0.25))
                    .frame(width: size, height: size)
            }
        }
    }
}
