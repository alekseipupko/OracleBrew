//
//  HistoryRepository.swift
//  OracleBrew
//
//  GET /history/ (paged) and the full-reading fetch behind a history row.
//

import Foundation

struct HistoryItemDTO: Decodable {
    let id: Int
    let drink: DrinkDTO
    let oracle: OracleDTO
    let topic: TopicDTO?
    let cupImage: String?
    let previewText: String?
    let adviceHeadline: String?
    let timeframeLabel: String?
    let hasChat: Bool?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, drink, oracle, topic
        case cupImage = "cup_image"
        case previewText = "preview_text"
        case adviceHeadline = "advice_headline"
        case timeframeLabel = "timeframe_label"
        case hasChat = "has_chat"
        case createdAt = "created_at"
    }
}

struct HistoryRepository {
    var emissary: Emissary = .shared

    func page(_ page: Int) async throws -> Paginated<HistoryItemDTO> {
        try await emissary.perform(
            EmissaryRequest(path: "history/", query: ["page": String(page)]),
            as: Paginated<HistoryItemDTO>.self
        )
    }

    func readingDetail(id: Int) async throws -> Reading {
        let dto = try await emissary.perform(EmissaryRequest(path: "readings/\(id)/"), as: ReadingDTO.self)
        return ReadingMapper.reading(dto.result)
    }
}

enum HistoryMapper {
    private static let isoFormatter = ISO8601DateFormatter()

    static func item(_ dto: HistoryItemDTO) -> HistoryItem {
        HistoryItem(
            id: dto.id,
            drink: CatalogMapper.drink(dto.drink),
            teller: CatalogMapper.oracle(dto.oracle),
            topic: dto.topic.map(CatalogMapper.topic),
            cupImageURL: dto.cupImage,
            preview: dto.previewText ?? "",
            adviceHeadline: dto.adviceHeadline ?? "",
            timeframe: dto.timeframeLabel ?? "",
            hasChat: dto.hasChat ?? false,
            date: dto.createdAt.flatMap { isoFormatter.date(from: $0) } ?? Date()
        )
    }
}
