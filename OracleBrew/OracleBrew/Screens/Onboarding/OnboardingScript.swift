import Foundation
import SwiftUI

/// What the user answers a step with.
enum OnboardingControl {
    case text                       // name
    case options([OnboardingChoice])
    case birthDate
    case relationshipWheel
    case employmentWheel
    case countryWheel
    case interests
}

/// One tappable answer in an `.options` step.
struct OnboardingChoice: Identifiable {
    let id: String
    let label: LocalizedStringKey
    /// Shown in the chat once picked — the design echoes the plain label.
    let echo: String
    /// The design plays the opt-out answer down: dark fill, not the gradient.
    var isNeutral = false
}

/// One question: the oracle's lines, then the control that answers them.
///
/// The oracle's lines are string catalog keys rather than LocalizedStringKey:
/// the flow resolves them so it can measure the text and time the typing to it.
struct OnboardingStep: Identifiable {
    let id: String
    /// Said before the question — the short reaction to the previous answer.
    var reaction: String?
    let question: String
    let control: OnboardingControl
}

enum OnboardingScript {
    /// Said once, before the first question.
    static let opening: [String] = [
        "onb.hello",
        "onb.intro"
    ]

    static let steps: [OnboardingStep] = [
        OnboardingStep(
            id: "name",
            question: "onb.q.name",
            control: .text
        ),
        // Spelled out rather than derived from Identity.allCases: this design
        // orders the opt-out first and words it its own way ("Prefer not to
        // say"), where the profile form says "Rather Not".
        OnboardingStep(
            id: "gender",
            // The reaction carries the name, so the flow builds it.
            question: "onb.q.gender",
            control: .options([
                OnboardingChoice(id: Identity.ratherNot.rawValue, label: "onb.gender.opt_out",
                                 echo: "Prefer not to say", isNeutral: true),
                OnboardingChoice(id: Identity.female.rawValue, label: "onb.gender.female", echo: "Female"),
                OnboardingChoice(id: Identity.male.rawValue, label: "onb.gender.male", echo: "Male")
            ])
        ),
        OnboardingStep(
            id: "birth",
            reaction: "onb.r.gender",
            question: "onb.q.birth",
            control: .birthDate
        ),
        OnboardingStep(
            id: "relationship",
            // The zodiac line is filled in from the answer, so it's not a plain
            // key — the flow substitutes the sign before sending it.
            question: "onb.q.relationship",
            control: .relationshipWheel
        ),
        OnboardingStep(
            id: "employment",
            reaction: "onb.r.relationship",
            question: "onb.q.employment",
            control: .employmentWheel
        ),
        OnboardingStep(
            id: "country",
            reaction: "onb.r.employment",
            question: "onb.q.country",
            control: .countryWheel
        ),
        // Same as gender: this design answers the question ("Yes / No"), where
        // the profile form labels the state ("Have children").
        OnboardingStep(
            id: "children",
            question: "onb.q.children",
            control: .options([
                OnboardingChoice(id: ChildrenStatus.have.rawValue, label: "onb.children.yes", echo: "Yes"),
                OnboardingChoice(id: ChildrenStatus.none.rawValue, label: "onb.children.no", echo: "No"),
                OnboardingChoice(id: ChildrenStatus.planning.rawValue, label: "onb.children.planning",
                                 echo: "Planning")
            ])
        ),
        OnboardingStep(
            id: "interests",
            question: "onb.q.interests",
            control: .interests
        )
    ]

    /// Lines the Loading screen cycles while the profile saves.
    static let loadingLines: [LocalizedStringKey] = [
        "onb.loading.1",
        "onb.loading.2",
        "onb.loading.3"
    ]
}
