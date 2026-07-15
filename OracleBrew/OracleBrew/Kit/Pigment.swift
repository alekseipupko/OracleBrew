//
//  Pigment.swift
//  OracleBrew
//
//  Color tokens. Source of truth: Figma (raw styles, no Figma variables).
//  Hardcoding colors in views is forbidden — always go through Pigment.
//

import SwiftUI

extension Color {
    init(hex: UInt32, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}

enum Pigment {
    /// App background — deep navy/purple.
    static let background = Color(hex: 0x130E24)
    /// Elevated surface — tab bar, icon chips.
    static let surface = Color(hex: 0x2C2142)

    /// Primary accent — active tab, labels.
    static let accent = Color(hex: 0xBB7EF7)
    /// Softer accent — circular arrow buttons.
    static let accentSoft = Color(hex: 0xA987D3)

    /// Warm cream — primary text on dark.
    static let cream = Color(hex: 0xFFEEE4)
    /// Cream at 50% — secondary text on dark.
    static let creamDim = Color(hex: 0xFFEEE4, alpha: 0.5)

    /// Muted lilac-grey — inactive tab labels.
    static let mutedText = Color(hex: 0x9D94B7)
    /// Muted purple-grey — card subtitles.
    static let cardSubtitle = Color(hex: 0x7A6F8E)
    /// Near-black navy — card titles on light cards.
    static let cardInk = Color(hex: 0x170D33)
    /// Gold — Pro Plan crown + label.
    static let gold = Color(hex: 0xFCBD1F)
    /// Settings/profile card fill — slightly lighter than background.
    static let settingsCard = Color(hex: 0x1A1430)
    /// Destructive — Delete Account.
    static let danger = Color(hex: 0xEF4444)

    /// Hairline border on form fields and unselected chips.
    static let fieldBorder = Color(hex: 0xFFFFFF, alpha: 0.07)
    /// Uppercase section label above a form field.
    static let fieldLabel = Color(hex: 0xFFEEE4, alpha: 0.2)
    /// Text inside an unselected chip / secondary field text.
    static let fieldMuted = Color(hex: 0xFFEEE4, alpha: 0.6)
    /// Selected chip fill — accent at 15%.
    static let chipSelected = Color(hex: 0xBB7EF7, alpha: 0.15)

    // Card gradients (angles ≈ Figma: 133° / 128°, mapped to topLeading→bottomTrailing).
    static let brewCard = LinearGradient(
        colors: [Color(hex: 0xF1E0D6), Color(hex: 0xE8C7B6)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let oracleCard = LinearGradient(
        colors: [Color(hex: 0xC7B6DC), Color(hex: 0x8972B1)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )

    /// Primary CTA gradient (Continue button, "Photo included" ribbon).
    static let accentGradient = LinearGradient(
        colors: [Color(hex: 0xBB7EF7), Color(hex: 0x8E4DCD)],
        startPoint: .leading, endPoint: .trailing
    )
}
