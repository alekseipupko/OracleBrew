import SwiftUI

struct OnboardingView: View {
    let store: UserProfileStore
    /// Onboarding is finished with — show the app.
    let onFinish: () -> Void

    @State private var flow = OnboardingFlow()
    @State private var askingToLeave = false

    var body: some View {
        ZStack {
            OnboardingBackground()

            switch flow.stage {
            case .asking:
                conversation
            case .saving:
                OnboardingLoadingView()
                    .task { await save() }
            case .ready:
                OnboardingReadyView(answers: flow.echoes,
                                    zodiac: flow.profile.zodiac,
                                    onStart: onFinish)
            }

            if askingToLeave {
                OnboardingLeavePopup(
                    onKeep: { askingToLeave = false },
                    onLeave: onFinish
                )
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .animation(.easeInOut(duration: 0.2), value: askingToLeave)
        .task { await flow.start() }
    }

    // MARK: Conversation

    private var conversation: some View {
        VStack(spacing: 0) {
            OnboardingHeader(progress: flow.progress) { askingToLeave = true }
                .padding(.horizontal, 20)
                .padding(.top, 12)

            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 10) {
                        ForEach(flow.lines) { OnboardingBubble(line: $0).id($0.id) }
                        if flow.isTyping { OnboardingTyping().id("typing") }
                        Color.clear.frame(height: 1).id("bottom")
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                .onChange(of: flow.lines.count) { scrollDown(proxy) }
                .onChange(of: flow.isTyping) { scrollDown(proxy) }
            }

            control
        }
    }

    private func scrollDown(_ proxy: ScrollViewProxy) {
        withAnimation(.easeOut(duration: 0.25)) { proxy.scrollTo("bottom", anchor: .bottom) }
    }

    /// Only ever built once the flow has unlocked a step.
    @ViewBuilder
    private var control: some View {
        if let step = flow.activeStep {
            Group {
                switch step.control {
                case .text:
                    OnboardingTextEntry { name in
                        answer(name) { $0.name = name }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)

                case .options(let choices):
                    OnboardingOptions(choices: choices) { choice in
                        answer(choice.echo) { apply(choice, to: &$0, step: step) }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)

                case .birthDate:
                    OnboardingPanel {
                        OnboardingBirthPicker { day, month, year in
                            answer(birthEcho(day: day, month: month, year: year)) {
                                $0.birthDay = day; $0.birthMonth = month; $0.birthYear = year
                            }
                        }
                    }

                case .relationshipWheel:
                    OnboardingPanel {
                        OnboardingWheel(values: RelationshipStatus.allCases, label: \.label) { value in
                            answer(value.label) { $0.relationship = value }
                        }
                    }

                case .employmentWheel:
                    OnboardingPanel {
                        OnboardingWheel(values: Employment.allCases, label: \.label) { value in
                            answer(value.label) { $0.employment = value }
                        }
                    }

                case .countryWheel:
                    OnboardingPanel {
                        OnboardingWheel(values: CountryCatalog.all,
                                        label: { "\($0.flag)  \($0.name)" }) { country in
                            answer("\(country.flag) \(country.name)") { $0.countryCode = country.id }
                        }
                    }

                case .interests:
                    OnboardingInterests { picked in
                        answer(interestsEcho(picked)) { $0.interests = picked }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
                }
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }

    private func answer(_ echo: String, apply: @escaping (inout UserProfile) -> Void) {
        Task { await flow.answer(echo, apply: apply) }
    }

    /// The option steps all carry enum raw values as their choice ids.
    private func apply(_ choice: OnboardingChoice, to profile: inout UserProfile, step: OnboardingStep) {
        switch step.id {
        case "gender": profile.identity = Identity(rawValue: choice.id)
        case "children": profile.children = ChildrenStatus(rawValue: choice.id)
        default: break
        }
    }

    private func birthEcho(day: Int, month: Int, year: Int) -> String {
        var components = DateComponents()
        components.day = day; components.month = month; components.year = year
        guard let date = Calendar(identifier: .gregorian).date(from: components) else {
            return "\(day)/\(month)/\(year)"
        }
        return date.formatted(.dateTime.day().month(.wide).year())
    }

    private func interestsEcho(_ picked: Set<String>) -> String {
        InterestCatalog.all
            .filter { picked.contains($0.id) }
            .map(\.label)
            .joined(separator: ", ")
    }

    // MARK: Save

    private func save() async {
        // The PATCH usually lands faster than the screen can be read, so hold
        // it for a beat — the point is to show the profile being made, not to
        // flash past. A failed save shouldn't strand the user here either; the
        // profile can still be filled in from Settings.
        async let saved: Void? = try? await store.save(flow.profile, completingOnboarding: true)
        async let held: Void? = try? await Task.sleep(for: .seconds(2))
        _ = await (saved, held)
        flow.markReady()
    }
}

/// "Creating profile" — shown while the single PATCH lands.
private struct OnboardingLoadingView: View {
    @State private var spin = false

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                ForEach(0..<8, id: \.self) { i in
                    Circle()
                        .fill(Pigment.accent.opacity(1 - Double(i) * 0.1))
                        .frame(width: 10 - CGFloat(i) * 0.6, height: 10 - CGFloat(i) * 0.6)
                        .offset(y: -22)
                        .rotationEffect(.degrees(Double(i) / 8 * 360))
                }
            }
            .frame(width: 56, height: 56)
            .rotationEffect(.degrees(spin ? 360 : 0))
            .animation(.linear(duration: 1.2).repeatForever(autoreverses: false), value: spin)

            Text("onb.loading.title")
                .font(Lettering.bodySemibold(14))
                .textCase(.uppercase)
                .foregroundStyle(Pigment.accent)
                .tracking(0.5)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(OnboardingScript.loadingLines.indices, id: \.self) { i in
                    Text(OnboardingScript.loadingLines[i])
                        .font(Lettering.body(14))
                        .foregroundStyle(Pigment.cream)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 4)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 28)
        .background(RoundedRectangle(cornerRadius: 24).fill(Pigment.onboardingPanel.opacity(0.7)))
        .padding(.horizontal, 20)
        .onAppear { spin = true }
    }
}

/// The filled-in profile, read back before the first reading. Shows the
/// answers as they were said in the chat, not labels re-derived from the model.
private struct OnboardingReadyView: View {
    let answers: [String: String]
    let zodiac: Zodiac?
    let onStart: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Text("onb.ready.title")
                .font(Lettering.displayMedium(30))
                .foregroundStyle(Pigment.cream)
                .multilineTextAlignment(.center)
            Text("onb.ready.subtitle")
                .font(Lettering.body(13))
                .foregroundStyle(Pigment.cream.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.top, 8)
                .padding(.horizontal, 32)

            summary
                .padding(.top, 24)
                .padding(.horizontal, 20)

            Spacer()

            OnboardingContinue(title: "onb.ready.cta", action: onStart)
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
        }
    }

    private var summary: some View {
        VStack(spacing: 12) {
            row("onb.sum.name", answers["name"])
            row("onb.sum.gender", answers["gender"])
            row("onb.sum.birth", answers["birth"])
            row("onb.sum.zodiac", zodiac.map { "\($0.name) \($0.glyph)" })
            row("onb.sum.relationship", answers["relationship"])
            row("onb.sum.employment", answers["employment"])
            row("onb.sum.country", answers["country"])
            row("onb.sum.children", answers["children"])
            row("onb.sum.interests", answers["interests"])
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 24).fill(Pigment.onboardingPanel.opacity(0.7)))
        .overlay(RoundedRectangle(cornerRadius: 24).strokeBorder(Color.white.opacity(0.1), lineWidth: 1))
    }

    @ViewBuilder
    private func row(_ label: LocalizedStringKey, _ value: String?) -> some View {
        if let value, !value.isEmpty {
            HStack(alignment: .top) {
                Text(label)
                    .font(Lettering.body(13))
                    .foregroundStyle(Pigment.cream.opacity(0.5))
                Spacer(minLength: 12)
                Text(value)
                    .font(Lettering.bodySemibold(13))
                    .foregroundStyle(Pigment.cream)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}

/// Skip is destructive — everything answered so far is dropped.
private struct OnboardingLeavePopup: View {
    let onKeep: () -> Void
    let onLeave: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()

            VStack(spacing: 0) {
                Text("onb.leave.title")
                    .font(Lettering.displayMedium(26))
                    .foregroundStyle(Pigment.cream)
                    .multilineTextAlignment(.center)
                Text("onb.leave.body")
                    .font(Lettering.body(13))
                    .foregroundStyle(Pigment.cream.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)

                OnboardingContinue(title: "onb.leave.keep", action: onKeep)
                    .padding(.top, 24)

                Button(action: onLeave) {
                    Text("onb.leave.confirm")
                        .font(Lettering.displayMedium(18))
                        .foregroundStyle(Pigment.cream)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Capsule().fill(Pigment.inkDeep))
                        .contentShape(Capsule())
                }
                .buttonStyle(.plain)
                .padding(.top, 12)
            }
            .padding(24)
            .background(RoundedRectangle(cornerRadius: 24).fill(Pigment.onboardingPanel))
            .overlay(RoundedRectangle(cornerRadius: 24).strokeBorder(Color.white.opacity(0.1), lineWidth: 1))
            .padding(.horizontal, 28)
        }
    }
}
