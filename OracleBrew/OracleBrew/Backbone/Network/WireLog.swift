//
//  WireLog.swift
//  OracleBrew
//
//  Prints what goes out and what comes back, for reading in the Xcode console.
//  DEBUG only — the whole thing compiles out of release builds, so the wire is
//  never echoed on a user's device.
//

import Foundation

enum WireLog {
    /// Header values that must never reach the console. The token is a live
    /// credential — printed once, it's in scrollback, in screenshots, and in
    /// whatever the log gets pasted into.
    private static let redactedHeaders = ["Authorization", "Cookie", "Set-Cookie"]

    /// Bodies past this are cut — a multipart cup photo is megabytes of noise.
    private static let bodyLimit = 2_000

    static func request(_ request: URLRequest) {
        #if DEBUG
        let method = request.httpMethod ?? "?"
        let url = request.url?.absoluteString ?? "?"
        var out = "\n→ \(method) \(url)"

        for (key, value) in request.allHTTPHeaderFields ?? [:] {
            out += "\n    \(key): \(redactedHeaders.contains(key) ? "<redacted>" : value)"
        }
        if let body = request.httpBody {
            out += "\n    body: \(describe(body, contentType: request.value(forHTTPHeaderField: "Content-Type")))"
        }
        print(out)
        #endif
    }

    static func response(_ response: HTTPURLResponse?, data: Data?, for request: URLRequest) {
        #if DEBUG
        let status = response?.statusCode ?? -1
        let method = request.httpMethod ?? "?"
        let url = request.url?.absoluteString ?? "?"
        // A failing status is what you're usually hunting for — make it findable.
        let mark = (200..<300).contains(status) ? "←" : "←✗"
        var out = "\n\(mark) \(status) \(method) \(url)"
        if let data, !data.isEmpty {
            out += "\n    \(describe(data, contentType: response?.value(forHTTPHeaderField: "Content-Type")))"
        }
        print(out)
        #endif
    }

    static func failure(_ error: Error, for request: URLRequest) {
        #if DEBUG
        print("\n←✗ \(request.httpMethod ?? "?") \(request.url?.absoluteString ?? "?")\n    \(error)")
        #endif
    }

    #if DEBUG
    /// JSON gets pretty-printed; anything binary is summarised, not dumped.
    private static func describe(_ data: Data, contentType: String?) -> String {
        if contentType?.contains("multipart") == true {
            return "<multipart, \(data.count) bytes>"
        }
        guard let text = String(data: data, encoding: .utf8) else {
            return "<binary, \(data.count) bytes>"
        }
        let pretty = prettyJSON(data) ?? text
        return pretty.count > bodyLimit
            ? String(pretty.prefix(bodyLimit)) + "… <\(pretty.count) chars total>"
            : pretty
    }

    private static func prettyJSON(_ data: Data) -> String? {
        guard let object = try? JSONSerialization.jsonObject(with: data),
              let formatted = try? JSONSerialization.data(
                withJSONObject: object, options: [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
              )
        else { return nil }
        return String(data: formatted, encoding: .utf8)
    }
    #endif
}
