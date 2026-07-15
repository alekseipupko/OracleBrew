//
//  ProfileChip.swift
//  OracleBrew
//

import SwiftUI

/// Pill option in a single-choice row (Identity / Employment / Children).
struct ProfileChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(Lettering.displayMedium(14))
                .foregroundStyle(isSelected ? Pigment.cream : Pigment.fieldMuted)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity)
                .frame(height: Cadence.tapTarget)
                .background(
                    Capsule().fill(isSelected ? Pigment.chipSelected : .clear)
                )
                .overlay(
                    Capsule().strokeBorder(isSelected ? Pigment.accent : Pigment.fieldBorder, lineWidth: 1)
                )
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

/// Interest chip — carries its own hue: filled when on, tinted when off.
struct InterestChip: View {
    let interest: Interest
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(interest.label)
                .font(Lettering.bodyMedium(14))
                .foregroundStyle(isSelected ? Pigment.background : interest.hue)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .frame(maxWidth: .infinity)
                .frame(height: Cadence.tapTarget)
                .background(
                    Capsule().fill(isSelected ? interest.hue : interest.hue.opacity(0.15))
                )
                .overlay(
                    Capsule().strokeBorder(isSelected ? interest.hue : interest.hue.opacity(0.4), lineWidth: 1)
                )
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

/// Uppercase label above every form section.
struct ProfileSectionLabel: View {
    let title: LocalizedStringKey

    var body: some View {
        Text(title)
            .font(Lettering.bodyMedium(12))
            .foregroundStyle(Pigment.fieldLabel)
            .textCase(.uppercase)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
