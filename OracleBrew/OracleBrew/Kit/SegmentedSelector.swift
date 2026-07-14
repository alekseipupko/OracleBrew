//
//  SegmentedSelector.swift
//  OracleBrew
//
//  Pill segmented control — the selected segment gets an accent outline.
//

import SwiftUI

struct SegmentedSelector<Item: Identifiable & Equatable>: View {
    let items: [Item]
    @Binding var selection: Item
    let title: (Item) -> LocalizedStringKey

    private let track = Color(hex: 0x271C3E)

    var body: some View {
        HStack(spacing: 4) {
            ForEach(items) { item in
                let isSelected = item == selection
                Button {
                    selection = item
                } label: {
                    Text(title(item))
                        .font(isSelected ? Lettering.body(14).weight(.semibold) : Lettering.body(14))
                        .foregroundStyle(isSelected ? Pigment.cream : Pigment.cream.opacity(0.4))
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(isSelected ? track : .clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22)
                                        .strokeBorder(isSelected ? Pigment.accent.opacity(0.4) : .clear, lineWidth: 1)
                                )
                        )
                        .contentShape(RoundedRectangle(cornerRadius: 22))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(Capsule().fill(track))
    }
}
