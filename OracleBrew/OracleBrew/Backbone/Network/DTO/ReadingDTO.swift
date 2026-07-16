//
//  ReadingDTO.swift
//  OracleBrew
//
//  Wire shapes for the reading flow: the reading itself, the AI job it kicks
//  off, and the result payload the screen renders.
//

import Foundation

struct AIJobDTO: Decodable {
    let id: Int
    let status: String          // pending | processing | succeeded | failed
    let error: String?
}

struct ReadingSymbolDTO: Decodable {
    struct SymbolDTO: Decodable {
        let id: Int
        let slug: String
        let name: String
        let shortMeaning: String?
        let baseDescription: String?
        let icon: String?

        enum CodingKeys: String, CodingKey {
            case id, slug, name, icon
            case shortMeaning = "short_meaning"
            case baseDescription = "base_description"
        }
    }

    let symbol: SymbolDTO
    let shortMeaning: String?
    let interpretation: String?
    let position: Int?

    enum CodingKeys: String, CodingKey {
        case symbol, interpretation, position
        case shortMeaning = "short_meaning"
    }
}

struct ReadingResultDTO: Decodable {
    let whatISee: String?
    let adviceHeadline: String?
    let timeframeLabel: String?
    let previewText: String?
    let symbols: [ReadingSymbolDTO]?

    enum CodingKeys: String, CodingKey {
        case symbols
        case whatISee = "what_i_see"
        case adviceHeadline = "advice_headline"
        case timeframeLabel = "timeframe_label"
        case previewText = "preview_text"
    }
}

struct ReadingDTO: Decodable {
    let id: Int
    let status: String          // draft | processing | completed | failed
    let aiJobId: Int?
    let hasChat: Bool?
    let cupImage: String?
    let result: ReadingResultDTO?

    enum CodingKeys: String, CodingKey {
        case id, status, result
        case aiJobId = "ai_job_id"
        case hasChat = "has_chat"
        case cupImage = "cup_image"
    }
}
