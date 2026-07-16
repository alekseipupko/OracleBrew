//
//  ChatThreadRow.swift
//  OracleBrew
//

import SwiftUI

struct ChatThreadRow: View {
    let summary: ChatSummary

    var body: some View {
        HStack(spacing: 12) {
            Group {
                if let url = summary.teller.portraitURL, !url.isEmpty {
                    RemoteImage(urlString: url, cornerRadius: 26)
                } else {
                    Image(summary.teller.portrait).resizable().scaledToFill()
                }
            }
            .frame(width: 52, height: 52)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(summary.teller.name)
                    .font(Lettering.displayMedium(16))
                    .foregroundStyle(Pigment.cream)
                Text(summary.preview)
                    .font(Lettering.body(12))
                    .foregroundStyle(Pigment.cream.opacity(0.5))
                    .lineLimit(1)
            }

            Spacer()

            if summary.hasUnread {
                Circle()
                    .fill(Pigment.accent)
                    .frame(width: 10, height: 10)
            } else {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Pigment.cream.opacity(0.3))
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: Cadence.cardRadius).fill(Color(hex: 0x1F1A2F)))
        .overlay(RoundedRectangle(cornerRadius: Cadence.cardRadius).strokeBorder(Color.white.opacity(0.1), lineWidth: 1))
    }
}
