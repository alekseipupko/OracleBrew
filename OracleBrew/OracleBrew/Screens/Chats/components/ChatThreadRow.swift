//
//  ChatThreadRow.swift
//  OracleBrew
//

import SwiftUI

struct ChatThreadRow: View {
    let thread: ChatThread

    private var preview: String {
        thread.messages.last?.text ?? "Say hello to start the conversation"
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(thread.teller.portrait)
                .resizable()
                .scaledToFill()
                .frame(width: 52, height: 52)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(thread.teller.name)
                    .font(Lettering.displayMedium(16))
                    .foregroundStyle(Pigment.cream)
                Text(preview)
                    .font(Lettering.body(12))
                    .foregroundStyle(Pigment.cream.opacity(0.5))
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Pigment.cream.opacity(0.3))
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: Cadence.cardRadius).fill(Color(hex: 0x1F1A2F)))
        .overlay(RoundedRectangle(cornerRadius: Cadence.cardRadius).strokeBorder(Color.white.opacity(0.1), lineWidth: 1))
    }
}
