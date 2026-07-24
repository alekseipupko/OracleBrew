import SwiftUI

@MainActor
@Observable
final class CatalogStore {
    private(set) var drinks: [Drink] = DrinkCatalog.all
    private(set) var oracles: [FortuneTeller] = FortuneTellerRoster.all
    private(set) var topics: [Topic] = TopicCatalog.all
    /// The home screen's daily line. Bundled, so it is on screen before the
    /// network answers and reads naturally in every language.
    private(set) var dailyFortune: String? = FortuneCatalog.fortune()

    private let repository: CatalogRepository
    private var loaded = false

    init(repository: CatalogRepository = CatalogRepository()) {
        self.repository = repository
    }

    /// Refresh from the API. Only non-empty results replace the mocks, so an
    /// unpopulated backend leaves the app fully usable.
    func refresh() async {
        guard !loaded else { return }
        loaded = true

        async let remoteDrinks = try? repository.drinks()
        async let remoteOracles = try? repository.oracles()
        async let remoteTopics = try? repository.topics()

        if let drinks = await remoteDrinks, !drinks.isEmpty {
            self.drinks = [DrinkCatalog.randomCup] + drinks
        }
        if let oracles = await remoteOracles, !oracles.isEmpty {
            self.oracles = oracles
        }
        if let topics = await remoteTopics, !topics.isEmpty {
            self.topics = topics
        }
    }

}
