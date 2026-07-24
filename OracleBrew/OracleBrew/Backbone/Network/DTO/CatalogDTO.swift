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
    /// The line under the name — "The Moon Seer". Distinct from the
    /// specializations, which are the topic chips.
    let profession: String?
    /// One-line card subtitle. Present but empty on every live oracle so far —
    /// the bundled copy covers it.
    let shortDescription: String?
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
        case id, slug, name, profession, illustration, rating, specializations, bio, reviews
        case shortDescription = "short_description"
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
