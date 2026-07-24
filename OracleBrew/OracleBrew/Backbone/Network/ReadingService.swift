import UIKit

struct ReadingService {
    var emissary: Emissary = .shared

    /// The end-to-end flow. Throws EmissaryFailure on any step; the reading id
    /// is returned alongside the result so the caller can start a chat from it.
    func generate(from draft: ReadingDraft) async throws -> (reading: Reading, readingID: Int) {
        let created = try await create(draft)
        _ = try await analyze(readingID: created.id)
        try await pollUntilDone(readingID: created.id)
        let full = try await fetchReading(id: created.id)
        return (ReadingMapper.reading(full.result), created.id)
    }

    // MARK: Steps

    private func create(_ draft: ReadingDraft) async throws -> ReadingDTO {
        guard let drinkID = draft.drink.flatMap({ Int($0.id) }),
              let oracleID = draft.teller.flatMap({ Int($0.id) }) else {
            throw EmissaryFailure.server(statusCode: -1)
        }
        let horizon = draft.horizon.rawValue

        // One path for both cases: the cup photo goes up as multipart. An
        // uploaded shot and a bundled Random-Cup photo are the same to the
        // backend — the Random path just picks its image from the bundle first.
        guard let photo = draft.photo,
              let jpeg = photo.jpegData(compressionQuality: 0.85) else {
            throw EmissaryFailure.server(statusCode: -1)
        }
        var parts: [MultipartPart] = [
            .field("drink_id", String(drinkID)),
            .field("oracle_id", String(oracleID)),
            .field("time_horizon", horizon),
            .file("cup_image", filename: "cup.jpg", mimeType: "image/jpeg", data: jpeg),
        ]
        if let topicID = draft.topic?.numericID { parts.append(.field("topic_id", String(topicID))) }
        if !draft.question.isEmpty { parts.append(.field("question", draft.question)) }
        let request = EmissaryRequest(path: "readings/", method: .post, body: .multipart(parts))
        return try await emissary.perform(request, as: ReadingDTO.self)
    }

    private func analyze(readingID: Int) async throws -> AIJobDTO {
        let request = EmissaryRequest(path: "readings/\(readingID)/analyze/", method: .post)
        return try await emissary.perform(request, as: AIJobDTO.self)
    }

    /// Polls the reading itself (its status mirrors the job) until it leaves
    /// processing. ~1.5s cadence, generous cap so a slow AI run still resolves.
    private func pollUntilDone(readingID: Int) async throws {
        for _ in 0..<40 {
            let reading = try await fetchReading(id: readingID)
            switch reading.status {
            case "completed": return
            case "failed": throw EmissaryFailure.server(statusCode: 502)
            default: try await Task.sleep(for: .milliseconds(1500))
            }
        }
        throw EmissaryFailure.server(statusCode: 504)   // timed out waiting
    }

    private func fetchReading(id: Int) async throws -> ReadingDTO {
        try await emissary.perform(EmissaryRequest(path: "readings/\(id)/"), as: ReadingDTO.self)
    }
}

enum ReadingMapper {
    static func reading(_ dto: ReadingResultDTO?) -> Reading {
        let symbols = (dto?.symbols ?? []).map { entry in
            // Name and keyword are the app's own vocabulary, so they come from
            // its catalog and translate with everything else. What the backend
            // writes for this particular reading — the interpretation — stays
            // the backend's, and the AI already produces it in the right
            // language. Its English-only symbol table is only ever a fallback.
            let local = SymbolCatalog.entry(forSlug: entry.symbol.slug)
            return ReadingSymbol(
                name: local?.name ?? entry.shortMeaning ?? entry.symbol.name,
                keyword: local?.keyword ?? entry.symbol.shortMeaning ?? "",
                meaning: entry.interpretation ?? entry.symbol.baseDescription ?? "",
                slug: entry.symbol.slug
            )
        }
        return Reading(
            symbols: symbols,
            whatISee: dto?.whatISee ?? "",
            advice: dto?.adviceHeadline ?? "",
            timeframe: dto?.timeframeLabel ?? ""
        )
    }
}

/// A tiny JSON value so a heterogeneous body ([String: …]) stays Encodable
/// without a bespoke struct per request.
enum AnyJSON: Encodable {
    case int(Int)
    case string(String)

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let value): try container.encode(value)
        case .string(let value): try container.encode(value)
        }
    }
}
