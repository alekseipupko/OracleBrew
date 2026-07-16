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
    /// Whether the account has an active subscription (GET /access/ → 200).
    /// v1.0 has no purchase flow, so this stays false, but the check is wired
    /// for when a paywall lands.
    private(set) var isPro = false

    private let emissary: Emissary

    init(emissary: Emissary = .shared) {
        self.emissary = emissary
    }

    /// 200 = subscribed, 403 = not. Any other failure leaves it false.
    func refreshAccess() async {
        do {
            try await emissary.performVoid(EmissaryRequest(path: "access/"))
            isPro = true
        } catch {
            isPro = false
        }
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
