import SwiftUI

struct SymbolChip: View {
    let symbol: ReadingSymbol

    var body: some View {
        HStack(spacing: 6) {
            Text(symbol.name)
                .font(Lettering.bodyMedium(14))
                .foregroundStyle(Pigment.cream)
            Text("→")
                .font(Lettering.body(13))
                .foregroundStyle(Pigment.cream.opacity(0.6))
            Text(symbol.keyword)
                .font(Lettering.body(14))
                .foregroundStyle(Pigment.accent)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color(hex: 0x271C3E)))
        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Color.white.opacity(0.15), lineWidth: 1))
    }
}
