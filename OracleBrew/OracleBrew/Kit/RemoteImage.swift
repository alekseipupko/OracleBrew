//
//  RemoteImage.swift
//  OracleBrew
//
//  System AsyncImage gives up after the first network hiccup (a dead keep-alive
//  connection) and shows nothing. This retries with backoff and shows a shimmer
//  while loading. Size is set by the backing shape; the image is an overlay
//  clipped to it, so scaledToFill can't blow out the container.
//

import SwiftUI

struct RemoteImage: View {
    let urlString: String?
    var cornerRadius: CGFloat = 12
    var contentMode: ContentMode = .fill

    @State private var image: Image?
    @State private var failed = false

    private var hasURL: Bool { !(urlString?.isEmpty ?? true) }

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Pigment.settingsCard)
            .overlay {
                if let image {
                    image.resizable().aspectRatio(contentMode: contentMode)
                } else if hasURL && !failed {
                    ShimmerFill(cornerRadius: cornerRadius)
                } else {
                    Image(systemName: "photo")
                        .font(.system(size: 24))
                        .foregroundStyle(Pigment.cream.opacity(0.25))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .task(id: urlString) { await load() }
    }

    @MainActor private func load() async {
        image = nil
        failed = false
        guard let urlString, !urlString.isEmpty, let url = URL(string: urlString) else { return }
        for attempt in 0..<3 {
            if Task.isCancelled { return }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let ui = UIImage(data: data) else { failed = true; return }
                withAnimation(.easeInOut(duration: 0.2)) { image = Image(uiImage: ui) }
                return
            } catch is CancellationError {
                return
            } catch {
                if attempt == 2 { failed = true; return }
                try? await Task.sleep(for: .milliseconds(300 * (attempt + 1)))
            }
        }
    }
}

/// Running light highlight across the backing while an image loads.
private struct ShimmerFill: View {
    let cornerRadius: CGFloat
    @State private var phase: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let w = max(geo.size.width, 1)
            Pigment.settingsCard
                .overlay(
                    LinearGradient(colors: [.clear, .white.opacity(0.15), .clear],
                                   startPoint: .leading, endPoint: .trailing)
                        .frame(width: w * 0.55)
                        .offset(x: -w + phase * (2 * w))
                )
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .onAppear {
                    withAnimation(.linear(duration: 1.1).repeatForever(autoreverses: false)) { phase = 1 }
                }
        }
    }
}
