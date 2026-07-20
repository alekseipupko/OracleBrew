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
