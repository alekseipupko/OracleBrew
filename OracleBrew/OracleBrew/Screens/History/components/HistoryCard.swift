//
//  HistoryCard.swift
//  OracleBrew
//

import SwiftUI

struct HistoryCard: View {
    let item: HistoryItem

    private var dateLabel: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: item.date)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            thumbnail

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text(item.drink.name)
                        .font(Lettering.bodyMedium(13))
                        .foregroundStyle(Pigment.cream)
                    Text("·")
                        .foregroundStyle(Pigment.cream.opacity(0.3))
                    Text(dateLabel)
                        .font(Lettering.body(11))
                        .foregroundStyle(Pigment.cream.opacity(0.4))
                }

                Text(item.preview)
                    .font(Lettering.body(12))
                    .foregroundStyle(Pigment.cream.opacity(0.6))
                    .lineLimit(2)

                HStack(spacing: 6) {
                    if let topic = item.topic {
                        TopicChip(text: topic.name, compact: true)
                    }
                    Spacer()
                    HStack(spacing: 4) {
                        Group {
                            if let url = item.teller.portraitURL, !url.isEmpty {
                                RemoteImage(urlString: url, cornerRadius: 9)
                            } else {
                                Image(item.teller.portrait).resizable().scaledToFill()
                            }
                        }
                        .frame(width: 18, height: 18)
                        .clipShape(Circle())
                        Text(item.teller.name)
                            .font(Lettering.body(11))
                            .foregroundStyle(Pigment.cream.opacity(0.4))
                    }
                    if item.hasChat {
                        Image(systemName: "bubble.left.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(Pigment.accent)
                    }
                }
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: Cadence.cardRadius).fill(Color(hex: 0x1F1A2F)))
        .overlay(RoundedRectangle(cornerRadius: Cadence.cardRadius).strokeBorder(Color.white.opacity(0.1), lineWidth: 1))
    }

    private var thumbnail: some View {
        Group {
            if let url = item.cupImageURL, !url.isEmpty {
                RemoteImage(urlString: url, cornerRadius: 14)
            } else {
                Image("SampleCupCard").resizable().scaledToFill()
            }
        }
        .frame(width: 64, height: 64)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
