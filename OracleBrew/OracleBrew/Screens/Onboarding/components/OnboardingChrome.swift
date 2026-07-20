import SwiftUI

/// Full-bleed art under a dark wash, so the bubbles stay readable over it.
struct OnboardingBackground: View {
    var body: some View {
        Pigment.inkDeep
            .overlay {
                Image("OnboardingBackground")
                    .resizable()
                    .scaledToFill()
            }
            .overlay {
                LinearGradient(
                    colors: [Pigment.inkDeep.opacity(0.55),
                             Pigment.inkDeep.opacity(0.75)],
                    startPoint: .top, endPoint: .bottom
                )
            }
            .ignoresSafeArea()
            // Deliberately hit-testable: onboarding sits over the app in a
            // ZStack, so the backdrop is what stops a tap that misses a control
            // from landing on the tab underneath.
            .contentShape(Rectangle())
    }
}

/// Progress pill + Skip. The bar fills left-to-right as steps are answered.
struct OnboardingHeader: View {
    let progress: Double
    let onSkip: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .leading) {
                Capsule().fill(Pigment.onboardingPanel)
                GeometryReader { geo in
                    Pigment.accent
                        .frame(width: max(30, geo.size.width * progress))
                }
                Text("onb.progress")
                    .font(Lettering.bodyMedium(12))
                    .foregroundStyle(Pigment.cream.opacity(0.6))
                    .frame(maxWidth: .infinity)
            }
            .frame(height: 33)
            .clipShape(Capsule())

            Button(action: onSkip) {
                Text("onb.skip")
                    .font(Lettering.bodyMedium(14))
                    .foregroundStyle(Pigment.cream)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Pigment.onboardingPanel))
                    // The design's pill is 33pt tall; stretch the hit area to
                    // the 44pt minimum without changing what's drawn.
                    .frame(minHeight: Cadence.tapTarget)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .animation(.easeOut(duration: 0.25), value: progress)
    }
}

/// One line of the conversation. The oracle speaks in italics from the left;
/// the user's answer echoes back in the accent gradient from the right.
struct OnboardingBubble: View {
    let line: OnboardingFlow.Line

    private var isUser: Bool { line.isFromUser }

    var body: some View {
        HStack(spacing: 0) {
            if isUser { Spacer(minLength: 40) }

            text
                .font(isUser ? Lettering.body(15) : Lettering.bodyItalic(15))
                .foregroundStyle(Pigment.cream)
                .lineSpacing(3)
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
                .background(background)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                // The tail overlaps the bubble rather than sitting beside it —
                // its own body is what fills the corner the radius rounds off.
                .background(alignment: isUser ? .bottomTrailing : .bottomLeading) { tail }

            if !isUser { Spacer(minLength: 40) }
        }
    }

    /// Verbatim: the flow already resolved this, and re-reading it as a key
    /// would look the finished sentence up in the catalog again.
    private var text: some View {
        Text(verbatim: line.text)
    }

    @ViewBuilder
    private var background: some View {
        if isUser { Pigment.accentGradient } else { Pigment.onboardingBubble }
    }

    private var tail: some View {
        BubbleTail(leading: !isUser)
            .fill(isUser ? AnyShapeStyle(Pigment.accentGradient)
                         : AnyShapeStyle(Pigment.onboardingBubble))
            .frame(width: BubbleTail.size.width, height: BubbleTail.size.height)
            // Only the tip clears the bubble; the rest tucks under it.
            .offset(x: isUser ? 3 : -3)
    }
}

/// Three dots while the oracle composes the next line.
struct OnboardingTyping: View {
    @State private var phase = 0

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(Pigment.cream.opacity(phase == i ? 0.9 : 0.3))
                    .frame(width: 6, height: 6)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(Capsule().fill(Pigment.onboardingBubble))
        .frame(maxWidth: .infinity, alignment: .leading)
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(350))
                phase = (phase + 1) % 3
            }
        }
    }
}

/// The blurred sheet the wheel pickers and their Continue button sit on.
struct OnboardingPanel<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 16) { content }
            .padding(.top, 16)
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            .frame(maxWidth: .infinity)
            .background {
                UnevenRoundedRectangle(topLeadingRadius: 32, topTrailingRadius: 32)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        UnevenRoundedRectangle(topLeadingRadius: 32, topTrailingRadius: 32)
                            .fill(Pigment.onboardingPanel.opacity(0.7))
                    }
            }
    }
}
