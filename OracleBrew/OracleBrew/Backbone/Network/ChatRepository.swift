//
//  ChatRepository.swift
//  OracleBrew
//
//  /chats/ — create-or-resume a thread with an oracle, fetch its messages and
//  quick questions, send a message (the reply comes back synchronously), and
//  list threads for the Chats tab.
//

import Foundation

struct ChatMessageDTO: Decodable {
    let id: Int
    let role: String          // user | assistant
    let text: String
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, role, text
        case createdAt = "created_at"
    }
}

struct ChatDetailDTO: Decodable {
    let id: Int
    let oracle: OracleDTO
    let readingId: Int?
    let quickQuestions: [String]?
    let messages: [ChatMessageDTO]?

    enum CodingKeys: String, CodingKey {
        case id, oracle, messages
        case readingId = "reading_id"
        case quickQuestions = "quick_questions"
    }
}

struct ChatListItemDTO: Decodable {
    let id: Int
    let oracle: OracleDTO
    let readingId: Int?
    let lastMessage: ChatMessageDTO?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, oracle
        case readingId = "reading_id"
        case lastMessage = "last_message"
        case updatedAt = "updated_at"
    }
}

struct SendMessageDTO: Decodable {
    let userMessage: ChatMessageDTO
    let assistantMessage: ChatMessageDTO

    enum CodingKeys: String, CodingKey {
        case userMessage = "user_message"
        case assistantMessage = "assistant_message"
    }
}

private struct CreateChatBody: Encodable {
    let oracleId: Int
    let readingId: Int?

    enum CodingKeys: String, CodingKey {
        case oracleId = "oracle_id"
        case readingId = "reading_id"
    }
}

private struct SendBody: Encodable {
    let text: String
}

struct ChatRepository {
    var emissary: Emissary = .shared

    /// Resumes the existing (oracle, reading) thread or opens a new one.
    func createOrResume(oracleID: Int, readingID: Int?) async throws -> ChatDetailDTO {
        let body = CreateChatBody(oracleId: oracleID, readingId: readingID)
        let request = EmissaryRequest(path: "chats/", method: .post, body: .json(body))
        return try await emissary.perform(request, as: ChatDetailDTO.self)
    }

    func detail(id: Int) async throws -> ChatDetailDTO {
        try await emissary.perform(EmissaryRequest(path: "chats/\(id)/"), as: ChatDetailDTO.self)
    }

    func send(chatID: Int, text: String) async throws -> SendMessageDTO {
        let request = EmissaryRequest(path: "chats/\(chatID)/messages/", method: .post, body: .json(SendBody(text: text)))
        return try await emissary.perform(request, as: SendMessageDTO.self)
    }

    func list(page: Int = 1) async throws -> Paginated<ChatListItemDTO> {
        try await emissary.perform(
            EmissaryRequest(path: "chats/", query: ["page": String(page)]),
            as: Paginated<ChatListItemDTO>.self
        )
    }
}

enum ChatMapper {
    static func message(_ dto: ChatMessageDTO) -> ChatMessage {
        ChatMessage(isFromUser: dto.role == "user", text: dto.text)
    }
}
