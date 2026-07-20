import Foundation

enum HTTPMethod: String {
    case get = "GET", post = "POST", patch = "PATCH", delete = "DELETE"
}

/// A request body, resolved into an encoded payload + content type at send time.
enum RequestBody {
    case none
    case json(any Encodable)
    case multipart([MultipartPart])
}

struct MultipartPart {
    let name: String
    let filename: String?
    let mimeType: String?
    let data: Data

    static func field(_ name: String, _ value: String) -> MultipartPart {
        MultipartPart(name: name, filename: nil, mimeType: nil, data: Data(value.utf8))
    }
    static func file(_ name: String, filename: String, mimeType: String, data: Data) -> MultipartPart {
        MultipartPart(name: name, filename: filename, mimeType: mimeType, data: data)
    }
}

struct EmissaryRequest {
    var path: String                       // relative to APIConfig.baseURL, trailing slash
    var method: HTTPMethod = .get
    var query: [String: String] = [:]
    var body: RequestBody = .none
    var requiresAuth = true
}

final class Emissary {
    static let shared = Emissary()

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    // MARK: Public

    func perform<T: Decodable>(_ request: EmissaryRequest, as type: T.Type) async throws -> T {
        let data = try await send(request)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw EmissaryFailure.decoding(error)
        }
    }

    /// For endpoints whose success body we don't read (logout, delete, analyze-fire).
    @discardableResult
    func performVoid(_ request: EmissaryRequest) async throws -> Data {
        try await send(request)
    }

    // MARK: Send

    @discardableResult
    private func send(_ request: EmissaryRequest) async throws -> Data {
        let urlRequest = try buildURLRequest(request)
        do {
            return try await run(urlRequest, retryOnDeadConnection: true)
        } catch let failure as EmissaryFailure {
            // Non-2xx is already on the log via the response; this is for the
            // rest (encoding, no token).
            throw failure
        } catch {
            WireLog.failure(error, for: urlRequest)
            throw mapURLError(error)
        }
    }

    private func run(_ urlRequest: URLRequest, retryOnDeadConnection: Bool) async throws -> Data {
        do {
            WireLog.request(urlRequest)
            let (data, response) = try await session.data(for: urlRequest)
            guard let http = response as? HTTPURLResponse else {
                WireLog.response(nil, data: data, for: urlRequest)
                throw EmissaryFailure.server(statusCode: -1)
            }
            WireLog.response(http, data: data, for: urlRequest)
            guard (200..<300).contains(http.statusCode) else {
                throw EmissaryFailure.from(statusCode: http.statusCode)
            }
            return data
        } catch let urlError as URLError where retryOnDeadConnection && Self.isDeadConnection(urlError) {
            WireLog.failure(urlError, for: urlRequest)
            // A reused keep-alive connection dies after idling: the first request
            // over it fails, a retry over a fresh one goes through. Safe — the
            // request never reached the server, so there's no response to lose.
            return try await run(urlRequest, retryOnDeadConnection: false)
        }
    }

    // MARK: Build

    private func buildURLRequest(_ request: EmissaryRequest) throws -> URLRequest {
        var components = URLComponents(
            url: APIConfig.baseURL.appendingPathComponent(request.path),
            resolvingAgainstBaseURL: false
        )!
        if !request.query.isEmpty {
            components.queryItems = request.query.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        var urlRequest = URLRequest(url: components.url!)
        urlRequest.httpMethod = request.method.rawValue

        // Non-GET must not be served from URLCache — a stale 404-after-delete or
        // duplicate-after-create would otherwise come back.
        if request.method != .get {
            urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        }

        if request.requiresAuth {
            guard let token = TokenVault.token else { throw EmissaryFailure.unauthorized }
            urlRequest.setValue(APIConfig.authValue(for: token), forHTTPHeaderField: "Authorization")
        }

        switch request.body {
        case .none:
            break
        case .json(let encodable):
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                urlRequest.httpBody = try JSONEncoder().encode(AnyEncodable(encodable))
            } catch {
                throw EmissaryFailure.encoding(error)
            }
        case .multipart(let parts):
            let boundary = "Boundary-\(UUID().uuidString)"
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = Self.encodeMultipart(parts, boundary: boundary)
        }

        return urlRequest
    }

    // MARK: Helpers

    private static func encodeMultipart(_ parts: [MultipartPart], boundary: String) -> Data {
        var body = Data()
        let crlf = "\r\n"
        for part in parts {
            body.append("--\(boundary)\(crlf)")
            var disposition = "Content-Disposition: form-data; name=\"\(part.name)\""
            if let filename = part.filename { disposition += "; filename=\"\(filename)\"" }
            body.append(disposition + crlf)
            if let mime = part.mimeType { body.append("Content-Type: \(mime)\(crlf)") }
            body.append(crlf)
            body.append(part.data)
            body.append(crlf)
        }
        body.append("--\(boundary)--\(crlf)")
        return body
    }

    private static func isDeadConnection(_ error: URLError) -> Bool {
        error.code == .networkConnectionLost || error.code == .timedOut
    }

    private func mapURLError(_ error: Error) -> EmissaryFailure {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .dataNotAllowed, .cannotConnectToHost,
                 .networkConnectionLost, .timedOut, .cannotFindHost:
                return .offline
            default:
                return .server(statusCode: urlError.errorCode)
            }
        }
        return .server(statusCode: -1)
    }
}

/// Lets `RequestBody.json` take any Encodable without a generic on the request.
private struct AnyEncodable: Encodable {
    private let encode: (Encoder) throws -> Void
    init(_ wrapped: any Encodable) { encode = wrapped.encode }
    func encode(to encoder: Encoder) throws { try encode(encoder) }
}

private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) { append(data) }
    }
}
