//
//  EmissaryFailure.swift
//  OracleBrew
//
//  Typed transport error. Separates "no internet" from a server fault so the
//  UI can tell the two apart (ScreenPhase.offline vs .loadFailure).
//

import Foundation

enum EmissaryFailure: Error {
    case offline
    case unauthorized                    // 401 — token missing or rejected
    case notSubscribed                   // 403 — /access/ without a subscription
    case notFound                        // 404
    case rateLimited                     // 429
    case server(statusCode: Int)
    case decoding(Error)
    case encoding(Error)

    /// True when re-authenticating (a fresh guest-signup) might recover.
    var isAuthProblem: Bool { if case .unauthorized = self { true } else { false } }
}

extension EmissaryFailure {
    static func from(statusCode: Int) -> EmissaryFailure {
        switch statusCode {
        case 401: .unauthorized
        case 403: .notSubscribed
        case 404: .notFound
        case 429: .rateLimited
        default: .server(statusCode: statusCode)
        }
    }
}
