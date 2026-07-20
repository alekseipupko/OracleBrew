import SwiftUI

/// Decoded images, kept in memory and keyed by URL. URLCache already spares the
/// download; this spares the decode — without it a card that scrolled away
/// shimmers again on its way back, because the view's state starts empty.
private enum DecodedImages {
    static let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = 96 << 20
        return cache
    }()

    static func image(for key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    static func store(_ image: UIImage, for key: String) {
        let cost = image.cgImage.map { $0.bytesPerRow * $0.height } ?? 0
        cache.setObject(image, forKey: key as NSString, cost: cost)
    }
}

struct RemoteImage: View {
    let urlString: String?
    var cornerRadius: CGFloat = 12
    var contentMode: ContentMode = .fill
    /// What sits behind the image. Cutout art (transparent PNGs) wants `.clear`
    /// so it blends into whatever the host draws, instead of reading as a box.
    var backing: Color = Pigment.settingsCard

    @State private var image: Image?
    @State private var failed = false

    private var hasURL: Bool { !(urlString?.isEmpty ?? true) }

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(backing)
            .overlay {
                if let image {
                    image.resizable().aspectRatio(contentMode: contentMode)
                } else if hasURL && !failed {
                    ShimmerFill(cornerRadius: cornerRadius, backing: backing)
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
        failed = false
        guard let urlString, !urlString.isEmpty, let url = URL(string: urlString) else {
            image = nil
            return
        }
        // Check the cache before clearing: assigning nil first would flash the
        // shimmer even when the image is already in hand.
        if let cached = DecodedImages.image(for: urlString) {
            image = Image(uiImage: cached)
            return
        }
        image = nil
        for attempt in 0..<3 {
            if Task.isCancelled { return }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let ui = UIImage(data: data) else { failed = true; return }
                DecodedImages.store(ui, for: urlString)
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
    var backing: Color = Pigment.settingsCard
    @State private var phase: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let w = max(geo.size.width, 1)
            backing
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
