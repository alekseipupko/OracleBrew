import Foundation
import SwiftUI

@MainActor
@Observable
final class OnboardingFlow {
    /// One line in the transcript. The text is resolved when it's said, rather
    /// than kept as a key — the flow has to measure it to time the typing.
    struct Line: Identifiable {
        let id = UUID()
        let isFromUser: Bool
        let text: String
    }

    enum Stage: Equatable {
        case asking
        case saving
        case ready
    }

    private(set) var lines: [Line] = []
    private(set) var stage: Stage = .asking
    /// nil while the oracle is still talking — the control stays hidden.
    private(set) var activeStep: OnboardingStep?
    private(set) var isTyping = false
    private(set) var stepIndex = 0

    var profile = UserProfile()
    /// step id → what the user answered, in the words it was echoed with. The
    /// summary reads these rather than re-deriving labels from the profile, so
    /// it reads back exactly what the conversation said.
    private(set) var echoes: [String: String] = [:]

    /// 0…1 for the header bar.
    var progress: Double {
        Double(stepIndex) / Double(OnboardingScript.steps.count)
    }

    // MARK: Pacing
    //
    // A fixed beat made every line land at the same speed, so a paragraph
    // arrived as fast as "Hi!" and the whole thing read as a burst. Instead:
    // she takes a moment before starting, then the dots run for as long as the
    // line would plausibly take to type.

    /// Pause before the dots appear — reading what you just said.
    private let readingPause: Duration = .milliseconds(450)
    /// Roughly 40 characters a second, floored and capped so one-word lines
    /// still register and paragraphs don't stall the flow.
    private let perCharacter: Duration = .milliseconds(25)
    private let minimumTyping: Duration = .milliseconds(500)
    private let maximumTyping: Duration = .seconds(2)

    private var started = false

    /// The save has landed (or failed — either way the answers are in hand).
    func markReady() {
        stage = .ready
    }

    func start() async {
        guard !started else { return }
        started = true
        for key in OnboardingScript.opening {
            await say(key)
        }
        await askCurrentStep()
    }

    /// Records an answer, echoes it, then moves on.
    func answer(_ echo: String, apply: (inout UserProfile) -> Void) async {
        guard let step = activeStep else { return }
        apply(&profile)
        echoes[step.id] = echo
        activeStep = nil                    // lock the control while she reacts
        lines.append(Line(isFromUser: true, text: echo))
        stepIndex += 1

        guard stepIndex < OnboardingScript.steps.count else {
            stage = .saving
            return
        }
        await askCurrentStep()
    }

    private func askCurrentStep() async {
        let step = OnboardingScript.steps[stepIndex]

        // Two reactions quote the answer back, so they're built here rather
        // than sitting in the script as plain keys.
        if step.id == "gender", !profile.name.isEmpty {
            await utter(String(localized: "onb.r.name \(profile.name)"))
        } else if step.id == "relationship", let sign = profile.zodiac {
            await utter(String(localized: "onb.r.birth \(sign.name)"))
        } else if let reaction = step.reaction {
            await say(reaction)
        }
        await say(step.question)
        activeStep = step
    }

    private func say(_ key: String) async {
        await utter(String(localized: String.LocalizationValue(key)))
    }

    private func utter(_ text: String) async {
        try? await Task.sleep(for: readingPause)
        isTyping = true
        try? await Task.sleep(for: typingTime(for: text))
        isTyping = false
        lines.append(Line(isFromUser: false, text: text))
    }

    private func typingTime(for text: String) -> Duration {
        let scaled = perCharacter * text.count
        return min(max(scaled, minimumTyping), maximumTyping)
    }
}
