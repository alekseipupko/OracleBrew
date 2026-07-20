import SwiftUI

/// Name entry — a rounded field over a Continue button.
struct OnboardingTextEntry: View {
    let onSubmit: (String) -> Void

    @State private var text = ""
    @FocusState private var focused: Bool

    private var trimmed: String { text.trimmingCharacters(in: .whitespacesAndNewlines) }

    var body: some View {
        VStack(spacing: 24) {
            TextField("onb.name.placeholder", text: $text)
                .font(Lettering.body(15))
                .foregroundStyle(Pigment.cream)
                .focused($focused)
                .submitLabel(.done)
                .onSubmit(submit)
                .padding(.horizontal, 20)
                .frame(height: 56)
                .background(Capsule().fill(Pigment.onboardingPanel.opacity(0.7)))
                .overlay(Capsule().strokeBorder(Pigment.accent.opacity(0.6), lineWidth: 1))

            if !trimmed.isEmpty {
                OnboardingContinue(action: submit)
            }
        }
        .animation(.easeOut(duration: 0.2), value: trimmed.isEmpty)
        .onAppear { focused = true }
    }

    private func submit() {
        guard !trimmed.isEmpty else { return }
        onSubmit(trimmed)
    }
}

/// A stack of full-width answers — tapping one answers the step outright, so
/// there's no Continue button.
struct OnboardingOptions: View {
    let choices: [OnboardingChoice]
    let onPick: (OnboardingChoice) -> Void

    var body: some View {
        VStack(spacing: 12) {
            ForEach(choices) { choice in
                Button { onPick(choice) } label: {
                    Text(choice.label)
                        .font(Lettering.displayMedium(20))
                        .foregroundStyle(Pigment.cream)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background {
                            if choice.isNeutral {
                                Capsule().fill(Pigment.onboardingPanel)
                            } else {
                                Capsule().fill(Pigment.accentGradient)
                            }
                        }
                        .contentShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
    }
}

/// Shared CTA under the wheel pickers.
struct OnboardingContinue: View {
    var title: LocalizedStringKey = "flow.continue"
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
    }
}

/// Day / month / year wheels. The native picker gives the design's tapered
/// wheel and selection band for free.
struct OnboardingBirthPicker: View {
    let onSubmit: (Int, Int, Int) -> Void

    @State private var day = 12
    @State private var month = 5
    @State private var year = 1994

    private static let months: [String] = {
        var calendar = Calendar(identifier: .gregorian)
        // A calendar built this way has no locale, and its monthSymbols come
        // back as "M01"… without one.
        calendar.locale = .current
        return calendar.monthSymbols
    }()

    private var years: [Int] {
        let now = Calendar.current.component(.year, from: Date())
        return Array((now - 100)...(now - 13)).reversed()
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 0) {
                Picker("", selection: $day) {
                    ForEach(1...daysInMonth, id: \.self) { Text("\($0)").tag($0) }
                }
                .pickerStyle(.wheel)
                .frame(width: 70)

                Picker("", selection: $month) {
                    ForEach(1...12, id: \.self) { Text(Self.months[$0 - 1]).tag($0) }
                }
                .pickerStyle(.wheel)
                .frame(width: 130)

                Picker("", selection: $year) {
                    ForEach(years, id: \.self) { Text(verbatim: "\($0)").tag($0) }
                }
                .pickerStyle(.wheel)
                .frame(width: 90)
            }
            .frame(height: 173)
            .colorScheme(.dark)
            .onChange(of: month) { clampDay() }
            .onChange(of: year) { clampDay() }

            OnboardingContinue { onSubmit(day, month, year) }
        }
    }

    private var daysInMonth: Int {
        var components = DateComponents()
        components.year = year
        components.month = month
        let calendar = Calendar(identifier: .gregorian)
        guard let date = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: date) else { return 31 }
        return range.count
    }

    /// 31 Jan → March keeps 31, but switching to February must not leave a day
    /// the month doesn't have.
    private func clampDay() {
        day = min(day, daysInMonth)
    }
}

/// Single-column wheel over a list of labelled values.
struct OnboardingWheel<Value: Hashable>: View {
    let values: [Value]
    let label: (Value) -> String
    let onSubmit: (Value) -> Void

    @State private var selection: Value?

    var body: some View {
        VStack(spacing: 16) {
            Picker("", selection: $selection) {
                ForEach(values, id: \.self) { value in
                    Text(label(value)).tag(Optional(value))
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 173)
            .colorScheme(.dark)

            OnboardingContinue {
                if let selection { onSubmit(selection) }
            }
        }
        .onAppear { selection = selection ?? values.first }
    }
}

/// Interest chips — the one step that takes several answers before Continue.
struct OnboardingInterests: View {
    let onSubmit: (Set<String>) -> Void

    @State private var picked: Set<String> = []

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)

    var body: some View {
        VStack(spacing: 16) {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(InterestCatalog.all) { interest in
                    InterestChip(interest: interest, isSelected: picked.contains(interest.id)) {
                        if picked.contains(interest.id) {
                            picked.remove(interest.id)
                        } else {
                            picked.insert(interest.id)
                        }
                    }
                }
            }
            if !picked.isEmpty {
                OnboardingContinue { onSubmit(picked) }
            }
        }
        .animation(.easeOut(duration: 0.2), value: picked.isEmpty)
    }
}
