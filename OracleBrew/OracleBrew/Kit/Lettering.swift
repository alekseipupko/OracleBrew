//
//  Lettering.swift
//  OracleBrew
//
//  Font tokens. Josefin Sans = display/headings, Inter = body/labels.
//  Fonts are bundled TTFs registered at launch (generated Info.plist, so no
//  UIAppFonts array — we register at runtime instead).
//

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

    /// Register bundled fonts once at app launch.
    static func registerFonts() {
        for name in ["JosefinSans-Regular", "JosefinSans-Medium", "JosefinSans-SemiBold", "Inter-Regular", "Inter-Medium"] {
            guard let url = Bundle.main.url(forResource: name, withExtension: "ttf") else {
                assertionFailure("Missing bundled font: \(name).ttf")
                continue
            }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}
