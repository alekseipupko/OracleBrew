import SwiftUI
import CoreText

enum Lettering {
    // MARK: Display — Josefin Sans
    static func display(_ size: CGFloat) -> Font { .custom("JosefinSans-Regular", size: size) }
    static func displayMedium(_ size: CGFloat) -> Font { .custom("JosefinSans-Medium", size: size) }
    static func displaySemibold(_ size: CGFloat) -> Font { .custom("JosefinSans-SemiBold", size: size) }

    // MARK: Body — Inter
    static func body(_ size: CGFloat) -> Font { .custom("Inter-Regular", size: size) }
    static func bodyMedium(_ size: CGFloat) -> Font { .custom("Inter-Medium", size: size) }
    static func bodySemibold(_ size: CGFloat) -> Font { .custom("Inter-SemiBold", size: size) }
    /// The oracle's voice in onboarding.
    static func bodyItalic(_ size: CGFloat) -> Font { .custom("Inter-Italic", size: size) }

    /// Register bundled fonts once at app launch.
    static func registerFonts() {
        for name in ["JosefinSans-Regular", "JosefinSans-Medium", "JosefinSans-SemiBold",
                     "Inter-Regular", "Inter-Medium", "Inter-SemiBold", "Inter-Italic"] {
            guard let url = Bundle.main.url(forResource: name, withExtension: "ttf") else {
                assertionFailure("Missing bundled font: \(name).ttf")
                continue
            }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}
