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
    /// Amber — warm end of the share card's cup ring.
    static let amber = Color(hex: 0xF59E0B)

    /// The darkest surface in the palette — under the onboarding art, and the
    /// fill for the chat's input field and the History card's menu chip.
    static let inkDeep = Color(hex: 0x130E24)

    // MARK: Onboarding-only
    /// Progress track, Skip pill, and the wheel-picker panel.
    static let onboardingPanel = Color(hex: 0x2C2142)
    /// The oracle's bubble.
    static let onboardingBubble = Color(hex: 0x38295C)

    /// Ring around the cup photo on the share card. Figma draws a gradient
    /// stroke, but Dev Mode flattens strokes to a single colour and the stops
    /// aren't variables — so this approximates it from the existing palette
    /// (accent → amber). Replace if the designer supplies the real stops.
    static let cupRing = LinearGradient(
        colors: [accent, amber],
        startPoint: .leading, endPoint: .trailing
    )

    /// Hairline border on form fields and unselected chips.
    static let fieldBorder = Color(hex: 0xFFFFFF, alpha: 0.07)
    /// Uppercase section label above a form field.
    static let fieldLabel = Color(hex: 0xFFEEE4, alpha: 0.2)
    /// Text inside an unselected chip / secondary field text.
    static let fieldMuted = Color(hex: 0xFFEEE4, alpha: 0.6)
    /// Selected chip fill — accent at 15%.
    static let chipSelected = Color(hex: 0xBB7EF7, alpha: 0.15)

    // Home card gradients. The Figma fills are angled (133° / 128° in CSS terms,
    // where 0° points up and 90° right) with an offset first stop — the light
    // colour holds for the first third, then eases into the darker one at the
    // bottom-right. A plain topLeading→bottomTrailing LinearGradient can't
    // express either the true angle (it collapses to the card's corner slope,
    // ~117° on this aspect) or the held stop, so CardGradient renders it exactly.
    static let brewCard = CardGradient.Spec(
        colors: [Color(hex: 0xF1E0D6), Color(hex: 0xE8C7B6)],
        stops: [0.384, 1], angle: 133.436
    )
    static let oracleCard = CardGradient.Spec(
        colors: [Color(hex: 0xC7B6DC), Color(hex: 0x8972B1)],
        stops: [0.471, 1], angle: 127.712
    )

    /// Primary CTA gradient (Continue button, "Photo included" ribbon).
    static let accentGradient = LinearGradient(
        colors: [Color(hex: 0xBB7EF7), Color(hex: 0x8E4DCD)],
        startPoint: .leading, endPoint: .trailing
    )

    // Splash. Its backdrop is its own gradient, not `background` — the splash
    // sits a shade darker than the app so the ball's glow carries.
    static let splashBackdrop = LinearGradient(
        colors: [Color(hex: 0x05060A), Color(hex: 0x0B1020)],
        startPoint: .top, endPoint: .bottom
    )
    /// Cool glow off the top-left corner, before blur.
    static let splashGlowTop = Color(hex: 0xB08AE0, alpha: 0.3)
    /// Warm glow off the bottom-right, before blur.
    static let splashGlowBottom = Color(hex: 0xFDE68A, alpha: 0.12)
    /// The sparkles beside the splash wordmark.
    static let splashSpark = Color(hex: 0xE5A772)
}
