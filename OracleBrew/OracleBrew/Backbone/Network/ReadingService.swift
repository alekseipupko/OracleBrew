//
//  ReadingService.swift
//  OracleBrew
//
//  Runs the whole Brew Reading server flow behind one call: create the reading
//  (photo upload or random cup), fire the AI job, poll it, then fetch and map
//  the result. The Loading screen awaits generate(from:); its spinner covers
//  exactly this work.
//

import UIKit

struct ReadingService {
    var emissary: Emissary = .shared
    var catalog = CatalogRepository()

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

        if draft.isRandomPath {
            // Random path: use the cup the user was shown on "Chosen for You".
            // It's picked there; only fetch here as a fallback if the screen was
            // somehow skipped.
            let cupID: Int
            if let chosen = draft.randomCupID {
                cupID = chosen
            } else {
                cupID = try await catalog.randomCup().id
            }
            var body: [String: AnyJSON] = [
                "drink_id": .int(drinkID),
                "oracle_id": .int(oracleID),
                "time_horizon": .string(horizon),
                "random_cup_id": .int(cupID),
            ]
            if let topicID = draft.topic?.numericID { body["topic_id"] = .int(topicID) }
            if !draft.question.isEmpty { body["question"] = .string(draft.question) }
            let request = EmissaryRequest(path: "readings/", method: .post, body: .json(body))
            return try await emissary.perform(request, as: ReadingDTO.self)
        } else {
            // Upload path: the cup photo as multipart.
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
            ReadingSymbol(
                name: entry.symbol.name,
                keyword: entry.shortMeaning ?? entry.symbol.shortMeaning ?? "",
                meaning: entry.interpretation ?? entry.symbol.baseDescription ?? ""
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
