//
//  HistoryCard.swift
//  OracleBrew
//

import SwiftUI

struct HistoryCard: View {
    let session: ReadingSession

    private var dateLabel: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: session.date)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            thumbnail

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text(session.drink.name)
                        .font(Lettering.bodyMedium(13))
                        .foregroundStyle(Pigment.cream)
                    Text("·")
                        .foregroundStyle(Pigment.cream.opacity(0.3))
                    Text(dateLabel)
                        .font(Lettering.body(11))
                        .foregroundStyle(Pigment.cream.opacity(0.4))
                }

                Text(session.reading.whatISee)
                    .font(Lettering.body(12))
                    .foregroundStyle(Pigment.cream.opacity(0.6))
                    .lineLimit(2)

                HStack(spacing: 6) {
                    if let topic = session.topic {
                        TopicChip(text: topic.name, compact: true)
                    }
                    Spacer()
                    HStack(spacing: 4) {
                        Image(session.teller.portrait)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 18, height: 18)
                            .clipShape(Circle())
                        Text(session.teller.name)
                            .font(Lettering.body(11))
                            .foregroundStyle(Pigment.cream.opacity(0.4))
                    }
                    if session.hasChatted {
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
        Color.clear
            .overlay {
                (session.photo.map { Image(uiImage: $0) } ?? Image("SampleCupCard"))
                    .resizable()
                    .scaledToFill()
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
