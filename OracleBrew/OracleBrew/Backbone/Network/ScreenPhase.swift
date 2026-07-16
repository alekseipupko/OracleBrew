//
//  ScreenPhase.swift
//  OracleBrew
//
//  The states any network-backed screen moves through. EmissaryFailure maps
//  straight in: .offline → .offline, everything else → .loadFailure.
//

import Foundation

enum ScreenPhase<Content> {
    case loading
    case content(Content)
    case loadFailure
    case offline

    static func from(_ failure: EmissaryFailure) -> ScreenPhase {
        if case .offline = failure { .offline } else { .loadFailure }
    }

    var isOffline: Bool { if case .offline = self { true } else { false } }
}
