//
//  CatalogStore.swift
//  OracleBrew
//
//  The shared source for drinks, oracles and topics. It starts from the
//  bundled mock catalogs so the UI has something to show immediately, then
//  refreshes from the API. While the backend catalogs are still empty (or a
//  fetch fails) it keeps the mocks — the screens never go blank; once the
//  server is populated, a real payload replaces them automatically.
//

import SwiftUI

@MainActor
@Observable
final class CatalogStore {
    private(set) var drinks: [Drink] = DrinkCatalog.all
    private(set) var oracles: [FortuneTeller] = FortuneTellerRoster.all
    private(set) var topics: [Topic] = TopicCatalog.all
    /// The home screen's daily line; nil until loaded (or if the backend has none).
    private(set) var dailyFortune: String?

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
        dailyFortune = await repository.dailyFortune()
    }

    /// A random cup for the "Chosen for You" screen. No drink is passed: only
    /// some drinks have cups on the backend, and constraining to one the user
    /// happened to land on 404s. Let the backend pick a cup that exists and
    /// report which drink it belongs to — the reading must use that drink.
    /// `excludeID` skips the one already shown, so "Choose Another Cup" never
    /// repeats it back.
    func randomCup(excludeID: Int? = nil) async throws -> (id: Int, imageURL: String?, drink: Drink) {
        let dto = try await repository.randomCup(excludeID: excludeID)
        return (dto.id, dto.image, CatalogMapper.drink(dto.drink))
    }
}
