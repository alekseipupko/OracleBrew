//
//  ReadingDraft.swift
//  OracleBrew
//
//  In-progress Brew Reading, shared across the flow steps via environment.
//  Grows as later steps (teller, intention, photo) land.
//

import SwiftUI

@Observable
final class ReadingDraft {
    var drink: Drink?
    /// True when the user picked "Random Cup" — `drink` still holds a real,
    /// concrete drink (randomly assigned at selection time) so downstream
    /// screens never display "Random" as if it were a drink name.
    var isRandomPath = false
    var teller: FortuneTeller?

    // Intention
    var horizon: TimeHorizon = .month
    var topic: Topic?
    var question: String = ""
    // photo added once its step is built.
}
