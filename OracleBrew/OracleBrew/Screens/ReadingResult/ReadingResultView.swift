//
//  ReadingResultView.swift
//  OracleBrew
//
//  Brew Reading — final step. Shows the mock ReadingEngine output: symbols,
//  a "what I see" paragraph, the teller's advice, and a predicted timeframe.
//  Share/save the cup photo, or continue into a chat with the chosen teller.
//

import SwiftUI

struct ReadingResultView: View {
    @Environment(ReadingDraft.self) private var draft
    /// Pre-computed reading to replay verbatim (History tab resume). When nil,
    /// the one the Loading step fetched from the API (`draft.reading`) is shown.
    var existingReading: Reading? = nil
    let onAskOracle: () -> Void
    let onClose: () -> Void

    @State private var reading: Reading?
    @State private var savedConfirmation = false
    /// Rendered once when the reading lands — ImageRenderer is too heavy to run
    /// on every body pass.
    @State private var shareCard: ShareCardImage?

    private let card = Color(hex: 0x271C3E)

    var body: some View {
        ZStack(alignment: .top) {
            Pigment.background.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                if let reading {
                    ScrollView(showsIndicators: false) {
                        content(reading)
                            .padding(.top, 20)
                            .padding(.bottom, 12)
                    }
                    // safeAreaInset reserves exactly its own height as extra
                    // scroll-content inset, so nothing ever peeks out below the
                    // button row — no magic-number bottom padding to guess at.
                    .safeAreaInset(edge: .bottom) {
                        actions
                            .padding(.top, 12)
                            .padding(.bottom, 8)
                            .background(Pigment.background.ignoresSafeArea(edges: .bottom))
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            guard reading == nil else { return }
            // existingReading = a History replay; draft.reading = the one the
            // Loading step fetched from the API; the engine is a last-ditch
            // fallback. History itself lives on the server now.
            let result = existingReading ?? draft.reading ?? ReadingEngine.generate(from: draft)
            reading = result
            if let image = ShareCardRenderer.render(photo: draft.photo, advice: result.advice,
                                                    timeframe: result.timeframe) {
                shareCard = ShareCardImage(image: image)
            }
        }
    }

    private var header: some View {
        ZStack {
            Text("result.title")
                .font(Lettering.displayMedium(24))
                .foregroundStyle(Pigment.cream)
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
        }
        .padding(.top, 4)
    }

    @ViewBuilder
    private func content(_ reading: Reading) -> some View {
        VStack(spacing: 24) {
            HStack(spacing: 9) {
                ThumbCard(
                    fallback: cupImage,
                    caption: "result.your_cup",
                    value: draft.drink.map { Text($0.name) } ?? Text("")
                )
                ThumbCard(
                    imageURL: draft.teller?.portraitURL,
                    fallback: draft.teller.map { Image($0.portrait) } ?? Image("SampleCupCard"),
                    caption: "result.your_oracle",
                    value: Text(draft.teller?.name ?? "")
                )
            }
            .frame(height: 172)

            whatISee(reading)
            keySymbols(reading)
            advice(reading)
        }
    }

    private var cupImage: Image {
        if let photo = draft.photo { Image(uiImage: photo) } else { Image("SampleCupCard") }
    }

    private func whatISee(_ reading: Reading) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "cup.and.saucer.fill").foregroundStyle(Pigment.cream)
                Text("result.what_i_see")
                    .font(Lettering.displayMedium(18))
                    .foregroundStyle(Pigment.cream)
            }
            Text(reading.whatISee)
                .font(Lettering.body(14))
                .foregroundStyle(Pigment.cream)
                .lineSpacing(4)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 24).fill(card))
        .overlay(RoundedRectangle(cornerRadius: 24).strokeBorder(Color.white.opacity(0.15), lineWidth: 1))
    }

    private func keySymbols(_ reading: Reading) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("result.key_symbols")
                .font(Lettering.displayMedium(18))
                .foregroundStyle(Pigment.cream)

            FlowLayout(spacing: 8) {
                ForEach(reading.symbols) { SymbolChip(symbol: $0) }
            }

            VStack(alignment: .leading, spacing: 16) {
                ForEach(reading.symbols) { symbol in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(symbol.name)
                            .font(Lettering.bodyMedium(14))
                            .foregroundStyle(Pigment.cream)
                        Text(symbol.meaning)
                            .font(Lettering.body(14).italic())
                            .foregroundStyle(Pigment.cream.opacity(0.8))
                            .lineSpacing(3)
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 24).fill(Color(hex: 0x1F1A2F)))
        }
    }

    private func advice(_ reading: Reading) -> some View {
        VStack(spacing: 12) {
            VStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .font(.system(size: 32))
                    .foregroundStyle(Pigment.accent)
                Text(reading.advice)
                    .font(Lettering.displayMedium(24))
                    .foregroundStyle(Pigment.cream)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                Text("result.advice_label")
                    .font(Lettering.body(12))
                    .foregroundStyle(Pigment.cream.opacity(0.4))
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 24).fill(card))
            .overlay(RoundedRectangle(cornerRadius: 24).strokeBorder(Color.white.opacity(0.15), lineWidth: 1))

            HStack(spacing: 6) {
                Image(systemName: "clock")
                    .font(.system(size: 14))
                    .foregroundStyle(Pigment.cream.opacity(0.6))
                Text("result.timeframe_label")
                    .font(Lettering.body(12))
                    .foregroundStyle(Pigment.cream.opacity(0.6))
                Text(reading.timeframe)
                    .font(Lettering.bodyMedium(12))
                    .foregroundStyle(Pigment.accent)
            }
        }
    }

    private var actions: some View {
        VStack(spacing: 8) {
            HStack(spacing: 9) {
                if let card = shareCard {
                    ShareLink(
                        item: card,
                        preview: SharePreview("share.preview_title", image: Image(uiImage: card.image))
                    ) {
                        secondaryLabel("result.share", icon: "square.and.arrow.up")
                    }
                } else {
                    secondaryLabel("result.share", icon: "square.and.arrow.up").opacity(0.4)
                }
                Button(action: savePhoto) {
                    secondaryLabel("result.save", icon: "arrow.down.to.line")
                }
                .buttonStyle(.plain)
            }
            PrimaryButton(title: "result.ask_oracle", action: onAskOracle)
        }
    }

    private func secondaryLabel(_ key: LocalizedStringKey, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon).font(.system(size: 18))
            Text(key).font(Lettering.displayMedium(18))
        }
        .foregroundStyle(Pigment.cream)
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .background(Capsule().fill(Color(hex: 0x19132B)))
        .overlay(Capsule().strokeBorder(Color.white.opacity(0.15), lineWidth: 1))
    }

    private func savePhoto() {
        guard let photo = draft.photo else { return }
        UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil)
    }
}
