import Foundation

struct DrinkDTO: Decodable {
    let id: Int
    let slug: String
    let title: String
    let description: String
    let image: String?
    let sortOrder: Int?

    enum CodingKeys: String, CodingKey {
        case id, slug, title, description, image
        case sortOrder = "sort_order"
    }
}

struct RandomCupDTO: Decodable {
    let id: Int
    let image: String?
    let drink: DrinkDTO
}

struct SpecializationDTO: Decodable {
    let id: Int
    let slug: String
    let title: String
}

struct ReviewDTO: Decodable {
    let id: Int
    let authorName: String
    let rating: Int
    let text: String
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, rating, text
        case authorName = "author_name"
        case createdAt = "created_at"
    }
}

struct OracleDTO: Decodable {
    let id: Int
    let slug: String
    let name: String
    let illustration: String?
    let rating: Double?
    let sessionsCount: Int?
    let specializations: [SpecializationDTO]?
    let sortOrder: Int?
    // Detail-only fields (nil in list responses).
    let bio: String?
    let reviews: [ReviewDTO]?
    let quickPrompts: [String]?

    enum CodingKeys: String, CodingKey {
        case id, slug, name, illustration, rating, specializations, bio, reviews
        case sessionsCount = "sessions_count"
        case sortOrder = "sort_order"
        case quickPrompts = "quick_prompts"
    }
}

struct TopicDTO: Decodable {
    let id: Int
    let slug: String
    let title: String
}
