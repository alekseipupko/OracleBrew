//
//  HistoryCard.swift
//  OracleBrew
//
//  One row in the History list, per the design: the oracle's photo on the left,
//  then the date, the topic chip, and two lines of the reading. A "…" menu sits
//  top-right — present only when a chat grew from this reading, and opening it
//  jumps into that chat. Tapping the card body opens the full result.
//

import SwiftUI

struct HistoryCard: View {
    let item: HistoryItem
    /// Opening the "…" menu jumps into the chat this reading led to.
    var onOpenChat: () -> Void = {}

    private var dateLabel: String {
        item.date.formatted(.dateTime.month(.wide).day().year()).uppercased()
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            portrait

            VStack(alignment: .leading, spacing: 8) {
                Text(dateLabel)
                    .font(Lettering.body(11))
                    .foregroundStyle(Pigment.cream.opacity(0.4))

                if let topic = item.topic {
                    TopicChip(text: topic.name, compact: true)
                }

                Text(item.preview)
                    .font(Lettering.body(13))
                    .foregroundStyle(Pigment.cream.opacity(0.7))
                    .lineSpacing(2)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 4)

            if item.hasChat {
                Button(action: onOpenChat) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Pigment.cream.opacity(0.6))
                        .frame(width: 36, height: 36)
                        .background(Circle().fill(Pigment.inkDeep))
                        .contentShape(Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: Cadence.cardRadius).fill(Color(hex: 0x1F1A2F)))
        .overlay(RoundedRectangle(cornerRadius: Cadence.cardRadius).strokeBorder(Color.white.opacity(0.1), lineWidth: 1))
    }

    private var portrait: some View {
        Group {
            if let url = item.teller.portraitURL, !url.isEmpty {
                RemoteImage(urlString: url, cornerRadius: 16)
            } else {
                Image(item.teller.portrait).resizable().scaledToFill()
            }
        }
        .frame(width: 80, height: 80)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
