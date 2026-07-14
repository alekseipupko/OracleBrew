//
//  PhotoUploadView.swift
//  OracleBrew
//
//  Brew Reading — step 4. Provide a cup photo: gallery, camera, or (for the
//  Random Cup path) a bundled sample. Empty state shows the drop zone; once a
//  photo exists it flips to the "Read Your Cup" preview.
//

import SwiftUI
import PhotosUI

struct PhotoUploadView: View {
    @Environment(ReadingDraft.self) private var draft
    let onContinue: () -> Void
    let onBack: () -> Void
    let onClose: () -> Void

    @State private var pickerItem: PhotosPickerItem?
    @State private var showCamera = false

    private let field = Color(hex: 0x271C3E)

    private var hasPhoto: Bool { draft.photo != nil }

    var body: some View {
        ZStack(alignment: .top) {
            Pigment.background.ignoresSafeArea()

            VStack(spacing: 0) {
                if hasPhoto {
                    previewHeader
                } else {
                    FlowHeader(title: "photo.title", subtitle: "photo.subtitle",
                               step: 4, onBack: onBack, onClose: onClose)
                    .padding(.top, 4)
                }

                zone
                    .padding(.top, hasPhoto ? 16 : 24)

                Spacer(minLength: 12)

                if !hasPhoto {
                    instructionCard
                        .padding(.bottom, 16)
                }
                buttons
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear(perform: prefillRandomIfNeeded)
        .onChange(of: pickerItem) { _, item in loadPicked(item) }
        .fullScreenCover(isPresented: $showCamera) {
            CameraPicker { draft.photo = $0 }.ignoresSafeArea()
        }
    }

    // MARK: Header (preview state — title + close only)

    private var previewHeader: some View {
        ZStack {
            Text("photo.preview.title")
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

    // MARK: Photo zone

    private var zone: some View {
        Group {
            if let photo = draft.photo {
                Color.clear
                    .overlay { Image(uiImage: photo).resizable().scaledToFill() }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                VStack(spacing: 16) {
                    ZStack {
                        Circle().fill(Pigment.accent.opacity(0.15)).frame(width: 72, height: 72)
                        Image(systemName: "camera.fill")
                            .font(.system(size: 26))
                            .foregroundStyle(Pigment.accent)
                    }
                    Text("photo.zone.hint")
                        .font(Lettering.body(14))
                        .foregroundStyle(Pigment.cream.opacity(0.4))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(RoundedRectangle(cornerRadius: 20).fill(field).opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Pigment.accent.opacity(0.5),
                                      style: StrokeStyle(lineWidth: 2, dash: [6, 5]))
                )
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 395 * Screen.vScale)
    }

    private var instructionCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "info.circle")
                .font(.system(size: 18))
                .foregroundStyle(Pigment.accent)
            Text("photo.instruction")
                .font(Lettering.body(12))
                .foregroundStyle(Pigment.cream.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 20).fill(field))
        .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.white.opacity(0.15), lineWidth: 1))
    }

    // MARK: Buttons

    @ViewBuilder
    private var buttons: some View {
        VStack(spacing: 12) {
            if hasPhoto {
                PhotosPicker(selection: $pickerItem, matching: .images) {
                    secondaryLabel("photo.select_another")
                }
                .buttonStyle(.plain)
                PrimaryButton(title: "photo.continue", action: onContinue)
            } else {
                PhotosPicker(selection: $pickerItem, matching: .images) {
                    secondaryLabel("photo.upload_gallery")
                }
                .buttonStyle(.plain)
                PrimaryButton(title: "photo.take") {
                    if CameraPicker.isAvailable { showCamera = true }
                }
            }
        }
    }

    private func secondaryLabel(_ key: LocalizedStringKey) -> some View {
        Text(key)
            .font(Lettering.displayMedium(20))
            .foregroundStyle(Pigment.cream)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Capsule().fill(Color(hex: 0x19132B)))
            .overlay(Capsule().strokeBorder(Color.white.opacity(0.15), lineWidth: 1))
            .contentShape(Capsule())
    }

    // MARK: Actions

    private func prefillRandomIfNeeded() {
        guard draft.isRandomPath, draft.photo == nil,
              let sample = UIImage(named: "SampleCup") else { return }
        draft.photo = sample
    }

    private func loadPicked(_ item: PhotosPickerItem?) {
        guard let item else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                await MainActor.run { draft.photo = image }
            }
        }
    }
}
