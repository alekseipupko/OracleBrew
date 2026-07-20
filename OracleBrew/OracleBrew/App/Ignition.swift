import SwiftUI

@main
struct Ignition: App {
    init() {
        Lettering.registerFonts()

        // URLCache refuses to store a response larger than 5% of its capacity,
        // and the catalog art runs 1–1.7 MB a piece. The default (~10 MB disk)
        // puts that ceiling at ~512 KB, so every cup image was silently
        // uncacheable and re-downloaded on each visit — hence the shimmer, even
        // though the server marks them `immutable` for 30 days.
        URLCache.shared = URLCache(memoryCapacity: 64 << 20, diskCapacity: 256 << 20)
    }

    var body: some Scene {
        WindowGroup {
            Atrium()
        }
    }
}
