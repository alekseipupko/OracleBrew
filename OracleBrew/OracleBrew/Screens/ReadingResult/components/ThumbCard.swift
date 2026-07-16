//
//  ThumbCard.swift
//  OracleBrew
//
//  Square photo card with a bottom gradient label — used for the "Your cup" /
//  "Your oracle" pair on the result screen.
//

import SwiftUI

struct ThumbCard: View {
    /// A server image URL takes precedence; `fallback` is the bundled art.
    var imageURL: String? = nil
    let fallback: Image
    let caption: LocalizedStringKey
    let value: Text

    var body: some View {
        Color.clear
            .overlay {
                if let imageURL, !imageURL.isEmpty {
                    RemoteImage(urlString: imageURL, cornerRadius: 24)
                } else {
                    fallback.resizable().scaledToFill()
                }
            }
            .overlay(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(caption)
                        .font(Lettering.bodyMedium(12))
                        .foregroundStyle(Pigment.cream.opacity(0.8))
                    value
                        .font(Lettering.displayMedium(20))
                        .foregroundStyle(Pigment.cream)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(colors: [Pigment.background.opacity(0), Pigment.background.opacity(0.85)],
                                   startPoint: .top, endPoint: .bottom)
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(RoundedRectangle(cornerRadius: 24).strokeBorder(Color.white.opacity(0.15), lineWidth: 2))
    }
}
