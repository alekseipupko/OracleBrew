import Foundation

enum APIConfig {
    /// Trailing slash matters — the backend redirects otherwise.
    static let baseURL = URL(string: "https://predict.oraclebrew.app/api/")!

    /// The docs use `Authorization: Token <token>`, not `Bearer`.
    static func authValue(for token: String) -> String { "Token \(token)" }

    static let pageSize = 12
}
