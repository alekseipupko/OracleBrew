//
//  FlowChrome.swift
//  OracleBrew
//
//  Shared chrome for the Brew Reading wizard: centered header + close, and the
//  primary gradient CTA. Reused across every flow step.
//

import SwiftUI

/// Centered title/subtitle with step dots, plus a top-right close chip.
struct FlowHeader: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let step: Int
    var onBack: (() -> Void)? = nil
    let onClose: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 4) {
                Text(title)
                    .font(Lettering.displayMedium(24))
                    .foregroundStyle(Pigment.cream)
                Text(subtitle)
                    .font(Lettering.body(12))
                    .foregroundStyle(Pigment.creamDim)
                    .multilineTextAlignment(.center)
                StepDots(current: step)
                    .padding(.top, 12)
            }
            .frame(maxWidth: .infinity)

            HStack {
                if let onBack {
                    chip(systemName: "arrow.left", action: onBack)
                }
                Spacer()
                chip(systemName: "xmark", action: onClose)
            }
        }
    }

    private func chip(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Pigment.cream)
                .frame(width: Cadence.tapTarget, height: Cadence.tapTarget)
                .background(Circle().fill(Pigment.surface))
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

/// Full-width gradient pill CTA.
struct PrimaryButton: View {
    let title: LocalizedStringKey
    var enabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Lettering.displayMedium(20))
                .foregroundStyle(Pigment.cream)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Capsule().fill(Pigment.accentGradient))
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .opacity(enabled ? 1 : 0.5)
        .disabled(!enabled)
    }
}

/// Full-width outlined secondary CTA (same footprint as PrimaryButton).
struct SecondaryButton: View {
    let title: LocalizedStringKey
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Lettering.displayMedium(20))
                .foregroundStyle(Pigment.cream)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Capsule().fill(Color(hex: 0x19132B)))
                .overlay(Capsule().strokeBorder(Color.white.opacity(0.15), lineWidth: 1))
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
