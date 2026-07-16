//
//  DrinkSelectionView.swift
//  OracleBrew
//
//  Brew Reading — step 1. Pick a drink (or Random Cup) from the catalog.
//

import SwiftUI

struct DrinkSelectionView: View {
    @Environment(ReadingDraft.self) private var draft
    @Environment(CatalogStore.self) private var catalog
    let onContinue: () -> Void
    let onClose: () -> Void

    /// Which catalog card is highlighted — kept separate from `draft.drink`
    /// because picking "Random Cup" reassigns `draft.drink` to a concrete
    /// drink while the Random Cup card itself should stay visually selected.
    @State private var selectedID: String?

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ZStack(alignment: .top) {
            Pigment.background.ignoresSafeArea()

            VStack(spacing: 0) {
                FlowHeader(
                    title: "drink.title",
                    subtitle: "drink.subtitle",
                    step: 1,
                    onClose: onClose
                )
                .padding(.top, 4)

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(catalog.drinks) { drink in
                            DrinkCard(
                                drink: drink,
                                isSelected: selectedID == drink.id,
                                dimmed: selectedID != nil && selectedID != drink.id
                            ) {
                                selectedID = drink.id
                                if drink.isRandom {
                                    draft.isRandomPath = true
                                    // Pick from the live catalog (real ids), not
                                    // the bundled mock, so the reading can create.
                                    let real = catalog.drinks.filter { !$0.isRandom }
                                    draft.drink = real.randomElement() ?? DrinkCatalog.randomPick()
                                } else {
                                    draft.isRandomPath = false
                                    draft.drink = drink
                                }
                            }
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 110)
                }
            }
            .padding(.horizontal, 20)

            if draft.drink != nil {
                continueBar
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var continueBar: some View {
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
