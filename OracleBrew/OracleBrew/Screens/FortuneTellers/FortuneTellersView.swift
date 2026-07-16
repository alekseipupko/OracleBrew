//
//  FortuneTellersView.swift
//  OracleBrew
//
//  Brew Reading — step 2. Pick an oracle (or open a full profile first).
//

import SwiftUI

struct FortuneTellersView: View {
    @Environment(ReadingDraft.self) private var draft
    @Environment(CatalogStore.self) private var catalog
    let onContinue: () -> Void
    let onOpenProfile: (FortuneTeller) -> Void
    let onBack: () -> Void
    let onClose: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            Pigment.background.ignoresSafeArea()

            VStack(spacing: 0) {
                FlowHeader(
                    title: "teller.title",
                    subtitle: "teller.subtitle",
                    step: 2,
                    onBack: onBack,
                    onClose: onClose
                )
                .padding(.top, 4)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(catalog.oracles) { teller in
                            TellerCard(
                                teller: teller,
                                isSelected: draft.teller == teller,
                                onSelect: { draft.teller = teller },
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
                    PrimaryButton(title: "flow.continue", action: onContinue)
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
