import SwiftUI

struct RandomCupView: View {
    @Environment(ReadingDraft.self) private var draft
    @Environment(CatalogStore.self) private var catalog
    let onContinue: () -> Void
    let onBack: () -> Void
    let onClose: () -> Void

    /// The asset currently shown, so "Choose Another Cup" avoids repeating it.
    @State private var shownAsset: String?

    var body: some View {
        ZStack(alignment: .top) {
            Pigment.background.ignoresSafeArea()

            VStack(spacing: 0) {
                FlowHeader(title: "random.title", subtitle: "random.subtitle",
                           step: 4, onBack: onBack, onClose: onClose)
                .padding(.top, 4)

                cupZone
                    .padding(.top, 24)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            // The info card and the two buttons are pinned to the bottom and
            // reserve their space first, so the photo above can only use what is
            // left — on a short screen it shrinks rather than shoving the
            // buttons off. This is the hard limit the flexible frame couldn't
            // give.
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 12) {
                    instructionCard
                    SecondaryButton(title: "random.another", action: chooseAnother)
                    PrimaryButton(title: "random.start", enabled: draft.photo != nil, action: onContinue)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 12)
                .background(Pigment.background.ignoresSafeArea(edges: .bottom))
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .task { if draft.photo == nil { pickCup() } }
    }

    // The design's photo box: 353×395 (a fixed 0.894 aspect), rounded 20, 20pt
    // side margins. Photos won't share an aspect, so the box is fixed and each
    // photo fills it — cropped, not letterboxed.
    private var cupZone: some View {
        // Color.clear is the size root: it holds the box's aspect, and the photo
        // fills it as an overlay that is then clipped. Putting the image
        // straight in the frame instead lets scaledToFill's own huge size drive
        // the layout, which is what made it bleed past the side margins. The
        // aspect fits within whatever height is left on a short screen, so it
        // shrinks rather than shoving the pinned buttons off.
        Color.clear
            .aspectRatio(353.0 / 395.0, contentMode: .fit)
            .frame(maxWidth: 353, maxHeight: 395)
            .overlay {
                if let photo = draft.photo {
                    Image(uiImage: photo).resizable().scaledToFill()
                } else {
                    Pigment.settingsCard
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .frame(maxWidth: .infinity)
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

    private func chooseAnother() { pickCup() }

    /// Draw a fresh random cup: a random real drink and one of its bundled
    /// photos. The chosen image becomes the reading's photo, so the reading is
    /// created by uploading it — exactly like a shot the user took. The drink is
    /// re-rolled too, so the button gives a genuinely different cup rather than
    /// just another angle of the same one.
    private func pickCup() {
        let reals = catalog.drinks.filter { !$0.isRandom }
        guard let drink = reals.randomElement() ?? catalog.drinks.first else { return }
        guard let cup = DrinkCatalog.randomCup(for: drink, excluding: shownAsset) else { return }
        draft.drink = drink
        draft.photo = cup.image
        shownAsset = cup.asset
    }
}
