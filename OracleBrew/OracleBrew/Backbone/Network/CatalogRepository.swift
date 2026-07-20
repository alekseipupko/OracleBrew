import SwiftUI

struct CatalogRepository {
    var emissary: Emissary = .shared

    func drinks() async throws -> [Drink] {
        let dtos = try await emissary.perform(EmissaryRequest(path: "drinks/"), as: [DrinkDTO].self)
        return dtos.map(CatalogMapper.drink)
    }

    func oracles() async throws -> [FortuneTeller] {
        let dtos = try await emissary.perform(EmissaryRequest(path: "oracles/"), as: [OracleDTO].self)
        return dtos.map(CatalogMapper.oracle)
    }

    func oracleDetail(id: String) async throws -> FortuneTeller {
        let dto = try await emissary.perform(EmissaryRequest(path: "oracles/\(id)/"), as: OracleDTO.self)
        return CatalogMapper.oracle(dto)
    }

    func topics() async throws -> [Topic] {
        let dtos = try await emissary.perform(EmissaryRequest(path: "topics/"), as: [TopicDTO].self)
        return dtos.map(CatalogMapper.topic)
    }

    func randomCup(excludeID: Int? = nil, drinkID: Int? = nil) async throws -> RandomCupDTO {
        var query: [String: String] = [:]
        if let excludeID { query["exclude_id"] = String(excludeID) }
        if let drinkID { query["drink_id"] = String(drinkID) }
        return try await emissary.perform(EmissaryRequest(path: "drinks/random/", query: query), as: RandomCupDTO.self)
    }

    /// The home screen's daily line. Returns nil when the backend has none
    /// (it answers 404 rather than an empty object).
    func dailyFortune() async -> String? {
        try? await emissary.perform(EmissaryRequest(path: "daily-fortune/"), as: DailyFortuneDTO.self).text
    }
}

struct DailyFortuneDTO: Decodable {
    let id: Int
    let text: String
}

enum CatalogMapper {
    /// Maps a backend drink slug to the bundled mock drink, so the API drinks
    /// borrow its artwork and gradient until the backend serves its own images.
    private static let mockIDBySlug: [String: String] = [
        "turkish_coffee": "turkish", "espresso": "espresso", "herbal_tea": "herbal",
        "tea_leaves": "tea", "matcha": "matcha", "hot_chocolate": "chocolate",
        "wine_sediment": "wine",
    ]

    static func drink(_ dto: DrinkDTO) -> Drink {
        let mock = mockIDBySlug[dto.slug].flatMap { id in DrinkCatalog.all.first { $0.id == id } }
        return Drink(
            id: String(dto.id),
            name: LocalizedStringKey(dto.title),
            blurb: LocalizedStringKey(dto.description),
            art: mock?.art ?? "",
            gradient: mock?.gradient ?? [Color(hex: 0x241649), Color(hex: 0x0E062C)],
            isRandom: false,
            imageURL: dto.image
        )
    }

    static func oracle(_ dto: OracleDTO) -> FortuneTeller {
        let specs = dto.specializations ?? []
        return FortuneTeller(
            id: String(dto.id),
            name: dto.name,
            title: specs.first?.title ?? "",
            portrait: "",
            rating: dto.rating ?? 0,
            sessions: dto.sessionsCount ?? 0,
            topics: specs.map(\.title),
            blurb: dto.bio ?? "",
            bio: dto.bio ?? "",
            reviews: (dto.reviews ?? []).map(review),
            portraitURL: dto.illustration
        )
    }

    static func review(_ dto: ReviewDTO) -> Review {
        Review(author: dto.authorName, stars: dto.rating, text: dto.text)
    }

    static func topic(_ dto: TopicDTO) -> Topic {
        // Recover the design colour by slug; unknown slugs get the accent.
        let colour = TopicCatalog.all.first { $0.id == dto.slug }?.color ?? Pigment.accent
        return Topic(id: dto.slug, name: dto.title, color: colour, numericID: dto.id)
    }
}
