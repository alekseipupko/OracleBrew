//
//  ChatBubble.swift
//  OracleBrew
//
//  Single message row — user bubbles trail right in the accent gradient,
//  oracle bubbles lead left in a dark surface.
//

import SwiftUI

struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isFromUser { Spacer(minLength: 40) }
            Text(message.text)
                .font(Lettering.body(14))
                .foregroundStyle(message.isFromUser ? Pigment.cardInk : Pigment.cream)
                .lineSpacing(3)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(bubbleBackground)
                .clipShape(RoundedRectangle(cornerRadius: 18))
            if !message.isFromUser { Spacer(minLength: 40) }
        }
    }

    @ViewBuilder
    private var bubbleBackground: some View {
        if message.isFromUser {
            Pigment.accentGradient
        } else {
            Color(hex: 0x271C3E)
        }
    }
}
