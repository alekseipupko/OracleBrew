//
//  ChatBubble.swift
//  OracleBrew
//
//  Single message row — user bubbles trail right in the accent gradient with a
//  tail on the right, oracle bubbles lead left in a dark surface with a tail on
//  the left. The tail is the design's own (Kit/BubbleTail).
//

import SwiftUI

struct ChatBubble: View {
    let message: ChatMessage

    private var isUser: Bool { message.isFromUser }
    private let oracleFill = Color(hex: 0x2C1E48)

    var body: some View {
        HStack(spacing: 0) {
            if isUser { Spacer(minLength: 44) }

            Text(message.text)
                .font(Lettering.bodyMedium(14))
                .foregroundStyle(Pigment.cream)
                .lineSpacing(3)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(background)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                // The tail tucks under the bubble and fills the corner the
                // radius rounds off; only its tip clears the edge.
                .background(alignment: isUser ? .bottomTrailing : .bottomLeading) { tail }

            if !isUser { Spacer(minLength: 44) }
        }
    }

    @ViewBuilder
    private var background: some View {
        if isUser { Pigment.accentGradient } else { oracleFill }
    }

    private var tail: some View {
        BubbleTail(leading: !isUser)
            .fill(isUser ? AnyShapeStyle(Pigment.accentGradient) : AnyShapeStyle(oracleFill))
            .frame(width: BubbleTail.size.width, height: BubbleTail.size.height)
            .offset(x: isUser ? 3 : -3)
    }
}
