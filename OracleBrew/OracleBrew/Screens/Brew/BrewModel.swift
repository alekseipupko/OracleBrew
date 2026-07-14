//
//  BrewModel.swift
//  OracleBrew
//

import SwiftUI

@Observable
final class BrewModel {
    /// Mock until onboarding profile lands (registration is done in-app).
    var userName: String = "Susan"

    // Hero copy is fixed daily-fortune content for v1.0 (no backend).
    let dailyHeadline: LocalizedStringKey = "brew.hero.headline"
}
