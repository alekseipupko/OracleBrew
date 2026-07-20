//
//  ChatThreadRow.swift
//  OracleBrew
//
//  One row in the Chats list. The avatar carries a small cup badge when the
//  chat grew out of a grounds reading (vs. a direct Oracle Chat); the timestamp
//  sits top-right, and an unread message from the oracle shows a dot.
//

import SwiftUI

struct ChatThreadRow: View {
    let summary: ChatSummary

    var body: some View {
        HStack(spacing: 12) {
            avatar

            VStack(alignment: .leading, spacing: 4) {
                Text(summary.teller.name)
                    .font(Lettering.displaySemibold(16))
                    .foregroundStyle(Pigment.cream)
                Text(summary.preview)
                    .font(Lettering.body(13))
                    .foregroundStyle(Pigment.cream.opacity(0.4))
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 8) {
                Text(RelativeTime.short(summary.date))
                    .font(Lettering.body(11))
                    .foregroundStyle(Pigment.cream.opacity(0.4))
                if summary.hasUnread {
                    Circle().fill(Pigment.accent).frame(width: 10, height: 10)
                } else {
                    Spacer().frame(height: 10)
                }
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: Cadence.cardRadius).fill(Color(hex: 0x1F1A2F)))
        .overlay(RoundedRectangle(cornerRadius: Cadence.cardRadius).strokeBorder(Color.white.opacity(0.1), lineWidth: 1))
    }

    private var avatar: some View {
        Group {
            if let url = summary.teller.portraitURL, !url.isEmpty {
                RemoteImage(urlString: url, cornerRadius: 26)
            } else {
                Image(summary.teller.portrait).resizable().scaledToFill()
            }
        }
        .frame(width: 52, height: 52)
        .clipShape(Circle())
        .overlay(alignment: .bottomTrailing) {
            if summary.fromReading { cupBadge }
        }
    }

    private var cupBadge: some View {
        Image(systemName: "cup.and.saucer.fill")
            .font(.system(size: 10))
            .foregroundStyle(Pigment.cream)
            .frame(width: 22, height: 22)
            .background(Circle().fill(Pigment.accent))
            .overlay(Circle().strokeBorder(Color(hex: 0x1F1A2F), lineWidth: 2))
    }
}
