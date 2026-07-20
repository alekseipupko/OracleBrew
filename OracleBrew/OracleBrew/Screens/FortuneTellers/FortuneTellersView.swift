import SwiftUI

struct FortuneTellersView: View {
    @Environment(ReadingDraft.self) private var draft
    @Environment(CatalogStore.self) private var catalog
    let onContinue: () -> Void
    let onOpenProfile: (FortuneTeller) -> Void
    let onBack: () -> Void
    let onClose: () -> Void
    /// Reading flow shows step dots + a back chip and a "Continue" CTA; the
    /// Oracle Chat entry is a single step — no progress, no back, "Start chat".
    var step: Int? = 2
    var ctaTitle: LocalizedStringKey = "flow.continue"

    var body: some View {
        ZStack(alignment: .top) {
            Pigment.background.ignoresSafeArea()

            VStack(spacing: 0) {
                FlowHeader(
                    title: "teller.title",
                    subtitle: "teller.subtitle",
                    step: step,
                    onBack: step == nil ? nil : onBack,
                    onClose: onClose
                )
                .padding(.top, 4)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(catalog.oracles) { teller in
                            TellerCard(
                                teller: teller,
                                isSelected: draft.teller == teller,
                                dimmed: draft.teller != nil && draft.teller != teller,
                                // Tapping the picked oracle again clears it.
                                onSelect: { draft.teller = draft.teller == teller ? nil : teller },
                                onViewProfile: { onOpenProfile(teller) }
                            )
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 110)
                }
            }
            .padding(.horizontal, 20)

            if draft.teller != nil {
                VStack {
                    Spacer()
                    PrimaryButton(title: ctaTitle, action: onContinue)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 8)
                        .background(
                            LinearGradient(
                                colors: [Pigment.background.opacity(0), Pigment.background],
                                startPoint: .top, endPoint: .bottom
                            )
                            .frame(height: 120)
                            .allowsHitTesting(false),
                            alignment: .bottom
                        )
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
