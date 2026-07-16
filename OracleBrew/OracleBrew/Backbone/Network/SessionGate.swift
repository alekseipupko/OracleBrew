//
//  SessionGate.swift
//  OracleBrew
//
//  Guarantees there's a token before any authed request runs. v1.0 has no
//  login screen, so on first launch we silently claim a guest account; the
//  onboarding screens later PATCH the profile against that same token.
//

import Foundation

private struct AuthResponse: Decodable {
    let token: String
    let shareCode: String

    enum CodingKeys: String, CodingKey {
        case token
        case shareCode = "share_code"
    }
}

@MainActor
@Observable
final class SessionGate {
    private(set) var isReady = false
    private(set) var startupFailed = false

    private let emissary: Emissary

    init(emissary: Emissary = .shared) {
        self.emissary = emissary
    }

    /// Called once at launch. Reuses an existing token, or claims a guest one.
    func start() async {
        if TokenVault.token != nil {
            isReady = true
            return
        }
        await claimGuest()
    }

    /// Re-claims a guest account after a 401 (token revoked server-side).
    func recoverFromUnauthorized() async {
        TokenVault.clear()
        isReady = false
        await claimGuest()
    }

    private func claimGuest() async {
        do {
            let request = EmissaryRequest(
                path: "auth/guest-signup/",
                method: .post,
                body: .json([String: String]()),
                requiresAuth: false
            )
            let response = try await emissary.perform(request, as: AuthResponse.self)
            TokenVault.save(response.token)
            startupFailed = false
            isReady = true
        } catch {
            startupFailed = true
            isReady = false
        }
    }
}
