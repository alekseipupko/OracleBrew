import SwiftUI

struct RandomCupView: View {
    @Environment(ReadingDraft.self) private var draft
    @Environment(CatalogStore.self) private var catalog
    let onContinue: () -> Void
    let onBack: () -> Void
    let onClose: () -> Void

    @State private var loading = false
    @State private var loadFailed = false

    var body: some View {
        ZStack(alignment: .top) {
            Pigment.background.ignoresSafeArea()

            VStack(spacing: 0) {
                FlowHeader(title: "random.title", subtitle: "random.subtitle",
                           step: 4, onBack: onBack, onClose: onClose)
                .padding(.top, 4)

                cupZone
                    .padding(.top, 24)

                Spacer(minLength: 12)

                instructionCard
                    .padding(.bottom, 16)

                SecondaryButton(title: "random.another", action: chooseAnother)
                    .padding(.bottom, 12)
                PrimaryButton(title: "random.start", enabled: draft.randomCupID != nil, action: onContinue)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
        }
        .toolbar(.hidden, for: .navigationBar)
        .task { if draft.randomCupID == nil { await load(excluding: nil) } }
        .alert("random.failed.title", isPresented: $loadFailed) {
            Button("common.retry") { chooseAnother() }
            Button("common.ok", role: .cancel) {}
        } message: {
            Text("random.failed.message")
        }
    }

    private var cupZone: some View {
        ZStack {
            if let url = draft.randomCupImageURL {
                RemoteImage(urlString: url, cornerRadius: 20)
            } else {
                RoundedRectangle(cornerRadius: 20).fill(Pigment.settingsCard)
            }
            if loading {
                ProgressView().tint(Pigment.accent)
            }
        }
        .frame(maxWidth: .infinity)
        // Same as the photo zone: fixed height overflows the column on SE.
        .frame(minHeight: 220, maxHeight: 395 * Screen.vScale)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var instructionCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "info.circle")
                .font(.system(size: 18))
                .foregroundStyle(Pigment.accent)
            Text("random.instruction")
                .font(Lettering.body(12))
                .foregroundStyle(Pigment.cream.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color(hex: 0x271C3E)))
        .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.white.opacity(0.15), lineWidth: 1))
    }

    private func chooseAnother() {
        Task { await load(excluding: draft.randomCupID) }
    }

    private func load(excluding excludeID: Int?) async {
        guard !loading else { return }
        loading = true
        defer { loading = false }
        do {
            let cup = try await catalog.randomCup(excludeID: excludeID)
            draft.randomCupID = cup.id
            draft.randomCupImageURL = cup.imageURL
            // The reading's drink must match the cup's — the backend chose both.
            draft.drink = cup.drink
        } catch {
            loadFailed = true
        }
    }
}
