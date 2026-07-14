//
//  Ignition.swift
//  OracleBrew
//

import SwiftUI

@main
struct Ignition: App {
    init() {
        Lettering.registerFonts()
    }

    var body: some Scene {
        WindowGroup {
            Atrium()
        }
    }
}
