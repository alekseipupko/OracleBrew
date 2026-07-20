import SwiftUI

struct TopicChip: View {
    let text: String
    var compact: Bool = false
    var accent: Bool = false

    var body: some View {
        Text(text)
            .font(Lettering.body(compact ? 10 : 12).weight(accent ? .regular : .medium))
            .foregroundStyle(accent ? Pigment.accent : Pigment.cream)
            .padding(.horizontal, compact ? 10 : 16)
            .padding(.vertical, compact ? 6 : 12)
            .background(
                Capsule().fill(compact ? Pigment.accent.opacity(0.15) : Color(hex: 0x271C3E))
            )
            .overlay(Capsule().strokeBorder(Pigment.accent.opacity(0.4), lineWidth: 1))
    }
}
