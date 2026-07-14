//
//  BrewReadingFlow.swift
//  OracleBrew
//
//  Container for the Brew Reading wizard. Owns the ReadingDraft and step stack.
//  Presented full-screen from the Brew tab.
//

import SwiftUI

enum ReadingStep: Hashable {
    case tellers, intention, photo, result
}

struct BrewReadingFlow: View {
    let onClose: () -> Void

    @State private var draft = ReadingDraft()
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            DrinkSelectionView(
                onContinue: { path.append(ReadingStep.tellers) },
                onClose: onClose
            )
            .navigationDestination(for: ReadingStep.self, destination: step)
            .navigationDestination(for: FortuneTeller.self) { teller in
                TellerProfileView(
                    teller: teller,
                    onContinue: {
                        draft.teller = teller
                        path.append(ReadingStep.intention)
                    },
                    onBack: pop
                )
            }
        }
        .environment(draft)
    }

    @ViewBuilder
    private func step(_ step: ReadingStep) -> some View {
        switch step {
        case .tellers:
            FortuneTellersView(
                onContinue: { path.append(ReadingStep.intention) },
                onOpenProfile: { path.append($0) },
                onBack: pop,
                onClose: onClose
            )
        case .intention:
            IntentionView(
                onContinue: { path.append(ReadingStep.photo) },
                onBack: pop,
                onClose: onClose
            )
        case .photo: FlowStub(title: "flow.step.photo", onClose: onClose)
        case .result: FlowStub(title: "flow.step.result", onClose: onClose)
        }
    }

    private func pop() {
        if !path.isEmpty { path.removeLast() }
    }
}

/// Temporary stand-in for a not-yet-built flow step.
struct FlowStub: View {
    let title: LocalizedStringKey
    let onClose: () -> Void

    var body: some View {
        ZStack {
            Pigment.background.ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Pigment.cream)
                            .frame(width: Cadence.tapTarget, height: Cadence.tapTarget)
                            .background(Circle().fill(Pigment.surface))
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
                Text(title)
                    .font(Lettering.displayMedium(24))
                    .foregroundStyle(Pigment.cream)
                Spacer()
            }
            .padding(20)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
