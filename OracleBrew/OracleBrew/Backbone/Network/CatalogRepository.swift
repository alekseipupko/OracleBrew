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
            // The backend's title/description are English-only. The bundled
            // drink for this slug already carries catalog keys, so it supplies
            // the words; the server's text is the fallback for a slug we don't
            // know yet, and shows up untranslated by design rather than by
            // accident.
            name: mock?.name ?? LocalizedStringKey(dto.title),
            blurb: mock?.blurb ?? LocalizedStringKey(dto.description),
            art: mock?.art ?? "",
            gradient: mock?.gradient ?? [Color(hex: 0x241649), Color(hex: 0x0E062C)],
            isRandom: false,
            imageURL: dto.image,
            // The Random Cup path draws from these bundled photos; a slug we
            // don't know yet simply has none and falls back to the sample.
            cupPhotos: mock?.cupPhotos ?? []
        )
    }

    /// The backend owns the oracle's identity; the app owns how it reads.
    ///
    /// Anything the bundle has copy for wins, because that copy is localized and
    /// the API's is English-only. The id, and therefore what a chat or reading is
    /// created against, always stays the backend's.
    static func oracle(_ dto: OracleDTO) -> FortuneTeller {
        let specs = dto.specializations ?? []
        let local = OracleContentCatalog.content(forSlug: dto.slug)
        let apiReviews = (dto.reviews ?? []).map(review)

        return FortuneTeller(
            id: String(dto.id),
            slug: dto.slug,
            name: local?.name ?? dto.name,
            // The design's subtitle is the profession; the first specialization
            // was only ever standing in for it.
            title: local?.profession ?? dto.profession ?? specs.first?.title ?? "",
            portrait: local?.portrait ?? "",
            rating: local?.rating ?? dto.rating ?? 0,
            sessions: local?.sessions ?? dto.sessionsCount ?? 0,
            topics: local?.topics ?? specs.map(\.title),
            // The card wants one line. `bio` is a paragraph, so it is only a
            // stand-in until short_description is filled in server-side.
            blurb: local?.shortDescription ?? dto.shortDescription ?? dto.bio ?? "",
            bio: local?.bio ?? dto.bio ?? "",
            reviews: local?.reviews ?? apiReviews,
            // Bundled art wins once it exists; until the assets land the
            // backend's illustration is the only picture there is.
            portraitURL: local?.hasArtwork == true ? nil : dto.illustration,
            reviewCount: local?.reviewCount ?? apiReviews.count
        )
    }

    static func review(_ dto: ReviewDTO) -> Review {
        Review(author: dto.authorName, stars: dto.rating, text: dto.text)
    }

    static func topic(_ dto: TopicDTO) -> Topic {
        // Recover the design colour by slug; unknown slugs get the accent.
        let colour = TopicCatalog.all.first { $0.id == dto.slug }?.color ?? Pigment.accent
        // The backend's `title` is English-only; ours translates.
        let name = TopicCatalog.localizedName(forSlug: dto.slug) ?? dto.title
        return Topic(id: dto.slug, name: name, color: colour, numericID: dto.id)
    }
}
