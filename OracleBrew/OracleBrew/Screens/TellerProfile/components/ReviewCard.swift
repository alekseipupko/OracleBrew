//
//  ReviewCard.swift
//  OracleBrew
//

import SwiftUI

struct ReviewCard: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(review.author)
                    .font(Lettering.bodyMedium(14))
                    .foregroundStyle(Pigment.cream)
                Spacer()
                StarRow(filled: review.stars, size: 18)
            }
            Text(review.text)
                .font(Lettering.body(14))
                .foregroundStyle(Pigment.cream.opacity(0.6))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color(hex: 0x2A1B3A)))
        .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Pigment.cream.opacity(0.1), lineWidth: 1))
    }
}
