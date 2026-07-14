//
//  TopicButton.swift
//  OracleBrew
//
//  Topic chip. Unselected: tinted wash + colored text. Selected: solid fill.
//

import SwiftUI

struct TopicButton: View {
    let topic: Topic
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(topic.name)
                .font(Lettering.bodyMedium(14))
                .foregroundStyle(isSelected ? Pigment.background : topic.color)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    Capsule().fill(isSelected ? topic.color : topic.color.opacity(0.15))
                )
                .overlay(
                    Capsule().strokeBorder(topic.color.opacity(isSelected ? 1 : 0.4), lineWidth: 1)
                )
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
