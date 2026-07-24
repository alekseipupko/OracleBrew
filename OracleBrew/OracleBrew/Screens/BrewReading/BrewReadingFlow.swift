import SwiftUI

enum ReadingStep: Hashable {
    case tellers, intention, photo, loading, result, chat
}

struct BrewReadingFlow: View {
    let onClose: () -> Void

    @Environment(ChatSessionStore.self) private var chatStore
    @State private var draft = ReadingDraft()
    @State private var path = NavigationPath()
    @State private var readingError: EmissaryFailure?

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
            .navigationDestination(for: TellerPeek.self) { peek in
                TellerProfileView(teller: peek.teller, onBack: pop)
            }
        }
        .environment(draft)
        .alert("reading.failed.title", isPresented: showReadingError) {
            Button("common.ok", role: .cancel) {}
        } message: {
            Text(readingError?.isOffline == true ? "reading.failed.offline" : "reading.failed.message")
        }
    }

    private var showReadingError: Binding<Bool> {
        Binding(get: { readingError != nil }, set: { if !$0 { readingError = nil } })
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
        case .photo:
            // Random Cup shows a bundled cup photo rather than asking for one —
            // same step in the wizard, different source.
            if draft.isRandomPath {
                RandomCupView(
                    onContinue: { path.append(ReadingStep.loading) },
                    onBack: pop,
                    onClose: onClose
                )
            } else {
                PhotoUploadView(
                    onContinue: { path.append(ReadingStep.loading) },
                    onBack: pop,
                    onClose: onClose
                )
            }
        case .loading:
            // Swap for the result rather than pushing on top of it — the reading
            // is the destination, and going back from it belongs at the photo
            // step, not at a spinner that would immediately run again.
            ReadingLoadingView(
                onDone: {
                    path.removeLast()
                    path.append(ReadingStep.result)
                },
                onFailure: { failure in
                    path.removeLast()          // back to the photo step
                    readingError = failure
                }
            )
        case .result:
            ReadingResultView(
                onAskOracle: { path.append(ReadingStep.chat) },
                onClose: onClose
            )
        case .chat:
            let teller = draft.teller ?? FortuneTellerRoster.all[0]
            OracleChatView(
                thread: chatStore.thread(for: teller, context: draft),
                onClose: onClose,
                onOpenProfile: { path.append(TellerPeek(teller: teller)) },
                onReturnToReading: pop
            )
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
