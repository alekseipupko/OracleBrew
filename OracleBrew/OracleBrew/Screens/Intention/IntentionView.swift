import SwiftUI

struct IntentionView: View {
    @Environment(ReadingDraft.self) private var draft
    @Environment(CatalogStore.self) private var catalog
    let onContinue: () -> Void
    let onBack: () -> Void
    let onClose: () -> Void

    @FocusState private var questionFocused: Bool

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)
    private let field = Color(hex: 0x271C3E)

    var body: some View {
        @Bindable var draft = draft

        return ZStack(alignment: .top) {
            Pigment.background.ignoresSafeArea()

            VStack(spacing: 0) {
                FlowHeader(
                    title: "intention.title",
                    subtitle: "intention.subtitle",
                    step: 3,
                    onBack: onBack,
                    onClose: onClose
                )
                .padding(.top, 4)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        section("intention.horizon") {
                            SegmentedSelector(
                                items: TimeHorizon.allCases,
                                selection: $draft.horizon
                            ) { $0.titleKey }
                        }

                        section("intention.topics") {
                            LazyVGrid(columns: columns, spacing: 8) {
                                ForEach(catalog.topics) { topic in
                                    TopicButton(topic: topic, isSelected: draft.topic == topic) {
                                        draft.topic = topic
                                    }
                                }
                            }
                        }

                        section("intention.question") {
                            questionField(text: $draft.question)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 110)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .padding(.horizontal, 20)

            if draft.topic != nil {
                VStack {
                    Spacer()
                    PrimaryButton(title: "flow.continue", action: onContinue)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 8)
                        .background(
                            LinearGradient(colors: [Pigment.background.opacity(0), Pigment.background],
                                           startPoint: .top, endPoint: .bottom)
                            .frame(height: 120).allowsHitTesting(false),
                            alignment: .bottom
                        )
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("common.done") { questionFocused = false }
            }
        }
    }

    private func section<Content: View>(
        _ title: LocalizedStringKey,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(Lettering.bodyMedium(12))
                .textCase(.uppercase)
                .foregroundStyle(Pigment.cream.opacity(0.2))
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func questionField(text: Binding<String>) -> some View {
        ZStack(alignment: .topLeading) {
            if text.wrappedValue.isEmpty {
                Text("intention.question.placeholder")
                    .font(Lettering.body(15))
                    .foregroundStyle(Pigment.cream.opacity(0.4))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .allowsHitTesting(false)
            }
            TextEditor(text: text)
                .font(Lettering.body(15))
                .foregroundStyle(Pigment.cream)
                .scrollContentBackground(.hidden)
                .focused($questionFocused)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
        }
        .frame(height: 90)
        .background(RoundedRectangle(cornerRadius: 20).fill(field))
        .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Pigment.accent.opacity(0.4), lineWidth: 1))
    }
}
